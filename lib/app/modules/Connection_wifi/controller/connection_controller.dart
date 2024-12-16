import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ConnectionController extends GetxController {
  final GetStorage _storage = GetStorage();
  final Connectivity _connectivity = Connectivity();
  final RxBool isConnected = false.obs;
  final RxList<Map<String, dynamic>> offlineData = <Map<String, dynamic>>[].obs;

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    _initializeConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      // Handle multiple results if needed, we are only interested in the first result
      _updateConnectionStatus(results.first);  // Assuming we want to use the first result
    });
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }

  Future<void> _initializeConnectivity() async {
    ConnectivityResult result;
    try {
      result = (await _connectivity.checkConnectivity()) as ConnectivityResult;
      _updateConnectionStatus(result);
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
    }
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
      isConnected.value = true;
      Get.snackbar(
        'Internet Connected',
        'Your device is connected to the internet.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      _uploadOfflineData();
    } else {
      isConnected.value = false;
      Get.snackbar(
        'No Internet Connection',
        'Your device is not connected to the internet.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> uploadDataToDatabase(Map<String, dynamic> data) async {
    if (isConnected.value) {
      try {
        // Simulate database upload (replace with your API/database call)
        await Future.delayed(Duration(seconds: 2));
        debugPrint('Data uploaded: $data');
      } catch (e) {
        debugPrint('Error uploading data: $e');
        _saveDataLocally(data);
      }
    } else {
      _saveDataLocally(data);
    }
  }

  void _saveDataLocally(Map<String, dynamic> data) {
    offlineData.add(data);
    _storage.write('offlineData', offlineData); // Save offline data to GetStorage
    debugPrint('Data saved locally: $data');
  }

  Future<void> _uploadOfflineData() async {
    final List<dynamic>? savedData = _storage.read<List<dynamic>>('offlineData');
    if (savedData != null && savedData.isNotEmpty) {
      for (var data in savedData) {
        try {
          // Simulate database upload (replace with your API/database call)
          await Future.delayed(Duration(seconds: 2));
          debugPrint('Offline data uploaded: $data');
        } catch (e) {
          debugPrint('Error uploading offline data: $e');
          return;
        }
      }
      // Clear offline data after successful upload
      offlineData.clear();
      _storage.remove('offlineData');
      debugPrint('All offline data uploaded and cleared.');
    }
  }
}