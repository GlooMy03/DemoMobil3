// buy_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyController extends GetxController {
  final RxBool isAgreed = false.obs;
  final RxString accountId = 'L4nturu'.obs;
  final RxDouble totalAmount = 32.999.obs;
  
  void toggleAgreement() {
    isAgreed.value = !isAgreed.value;
  }
  
  void processPurchase() {
    if (!isAgreed.value) {
      Get.snackbar(
        'Error',
        'Please agree to the terms and conditions',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    // Show success snackbar
    Get.snackbar(
      'Berhasil',
      'Terimakasih telah membeli game ini!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
    );

    // Navigate to home screen after short delay
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAllNamed('/home'); // This will clear the navigation stack and go to home
    });
  }
}