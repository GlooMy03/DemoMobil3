import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  var isLoading = false.obs;
  var selectedImagePath = ''.obs;
  var name = ''.obs;
  var phone = ''.obs;
  var email = ''.obs;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var locationName = ''.obs;

  var mapController = Completer<GoogleMapController>();

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    loadProfile();
    getCurrentLocation();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }

// Fungsi untuk mendapatkan lokasi
  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Periksa apakah layanan lokasi aktif
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar("Error", "Layanan lokasi tidak aktif.");
        return;
      }

      // Periksa izin lokasi
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar("Error", "Izin lokasi ditolak.");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar("Error", "Izin lokasi ditolak permanen.");
        return;
      }

      // Ambil lokasi perangkat
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      latitude.value = position.latitude;
      longitude.value = position.longitude;

      // Setelah mendapatkan koordinat, ambil nama lokasi
      await getLocationName();
    } catch (e) {
      Get.snackbar("Error", "Gagal mendapatkan lokasi: $e");
    }
  }

  // Fungsi untuk mendapatkan nama lokasi berdasarkan koordinat
  Future<void> getLocationName() async {
    try {
      // Mengonversi latitude dan longitude menjadi nama lokasi
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude.value,
        longitude.value,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        locationName.value =
            '${place.locality}, ${place.administrativeArea}, ${place.country}';
      } else {
        locationName.value = 'Lokasi tidak ditemukan';
      }
    } catch (e) {
      locationName.value = 'Error mendapatkan lokasi: $e';
    }
  }

  // Fungsi untuk membuka Google Maps
  Future<void> openGoogleMaps() async {
    final googleMapsUrl =
        'https://www.google.com/maps?q=${latitude.value},${longitude.value}';
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      Get.snackbar("Error", "Tidak dapat membuka Google Maps.");
    }
  }

  Future<void> updateLocationInFirebase() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'latitude': latitude.value,
          'longitude': longitude.value,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
        print('Location updated in Firebase');
      }
    } catch (e) {
      print('Error updating location in Firebase: $e');
      Get.snackbar('Error', 'Failed to update location: $e');
    }
  }

  Future<void> loadProfile() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          final userData = userDoc.data()!;
          nameController.text = userData['name'] ?? '';
          phoneController.text = userData['phone'] ?? '';
          emailController.text = userData['email'] ?? '';
          selectedImagePath.value = userData['profileImageUrl'] ?? '';
          name.value = nameController.text;
          phone.value = phoneController.text;
          email.value = emailController.text;
        }
      }
    } catch (e) {
      print('Debug: Error loading profile: $e');
      Get.snackbar(
        'Error',
        'Failed to load profile: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        print('Debug: Image picked: ${image.path}');
        selectedImagePath.value = image.path;
        await uploadProfileImage(File(image.path));
      }
    } catch (e) {
      print('Debug: Error picking image: $e');
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
      );
    }
    Get.back();
  }

  Future<void> uploadProfileImage(File imageFile) async {
    try {
      isLoading.value = true;
      final user = _auth.currentUser;
      if (user == null) {
        print('Debug: User not logged in');
        Get.snackbar('Error', 'Please login first');
        return;
      }

      print('Debug: Starting upload for user ${user.uid}');

      // Create file reference
      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = _storage.ref().child('users/${user.uid}/$fileName');

      print('Debug: Storage reference created');

      // Upload with metadata
      final metadata = SettableMetadata(
          contentType: 'image/jpeg', customMetadata: {'userId': user.uid});

      // Start upload and show progress
      final uploadTask = storageRef.putFile(imageFile, metadata);

      // Monitor upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress =
            (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        print('Debug: Upload progress: ${progress.toStringAsFixed(2)}%');
      });

      // Wait for upload to complete
      await uploadTask;
      print('Debug: File uploaded successfully');

      // Get download URL
      final imageUrl = await storageRef.getDownloadURL();
      print('Debug: Download URL obtained: $imageUrl');

      // Update Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'profileImageUrl': imageUrl,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      selectedImagePath.value = imageUrl;

      Get.snackbar(
        'Success',
        'Profile image uploaded successfully',
        backgroundColor: const Color(0xFF64FFDA),
        colorText: Colors.black,
      );
    } catch (e) {
      print('Debug: Error during upload: $e');
      Get.snackbar(
        'Error',
        'Failed to upload image: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void showImagePickerBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choose Profile Photo',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImagePickerOption(
                  icon: Icons.photo_camera,
                  label: 'Camera',
                  onTap: () => pickImage(ImageSource.camera),
                ),
                _buildImagePickerOption(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () => pickImage(ImageSource.gallery),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildImagePickerOption({
    required IconData icon,
    required String label,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 30,
              color: const Color(0xFF64FFDA),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateProfile() async {
    try {
      isLoading.value = true;
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': nameController.text,
          'phone': phoneController.text,
          'email': emailController.text,
        }, SetOptions(merge: true));

        name.value = nameController.text;
        phone.value = phoneController.text;
        email.value = emailController.text;

        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF64FFDA),
          colorText: Colors.black,
        );
      }
    } catch (e) {
      print('Debug: Error updating profile: $e');
      Get.snackbar(
        'Error',
        'Failed to update profile: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
