import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/profile_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1228),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1228),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF64FFDA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: controller.updateProfile,
              child: const Text(
                'SAVE',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // Profile Picture
            Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Obx(() {
                        final imagePath = controller.selectedImagePath.value;
                        return CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[800],
                          child: ClipOval(
                            child: imagePath.isEmpty
                                ? const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.white54,
                                  )
                                : imagePath.startsWith('http')
                                    ? CachedNetworkImage(
                                        imageUrl: imagePath,
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.error,
                                          color: Colors.red,
                                        ),
                                      )
                                    : Image.file(
                                        File(imagePath),
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                          ),
                        );
                      }),
                      Positioned(
                        bottom: -5,
                        child: GestureDetector(
                          onTap: controller.showImagePickerBottomSheet,
                          child: Container(
                            width: 80,
                            height: 15,
                            decoration: BoxDecoration(
                              color: const Color(0xFF64FFDA),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24), // Jarak antara foto dan text field nama

            // Text Fields
            _buildTextField(
              label: 'Name',
              controller: controller.nameController,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Nomor Hp',
              controller: controller.phoneController,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Email',
              controller: controller.emailController,
            ),
            const SizedBox(height: 32),

            // Location Details
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Location Details',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Obx(() {
                  final latitude = controller.latitude.value;
                  final longitude = controller.longitude.value;
                  final location = controller.locationName.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLocationInfo('Latitude', latitude.toString()),
                      _buildLocationInfo('Longitude', longitude.toString()),
                      _buildLocationInfo('Location', location.isEmpty ? 'No location found' : location),
                    ],
                  );
                }),
                const SizedBox(height: 16),
                Obx(() => controller.latitude.value != 0.0 &&
                        controller.longitude.value != 0.0
                    ? GestureDetector(
                        onTap: controller.openGoogleMaps,
                        child: const Text(
                          'Lihat Lokasi Di Google Maps',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    : const SizedBox.shrink()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF172A47),
            hintText: label,
            hintStyle: const TextStyle(color: Colors.white54),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
