// File 1: /lib/app/modules/buy/controllers/buy_controller.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coba4/app/modules/wishlist/controller/wishlist_controller.dart';

class BuyController extends GetxController {
  final RxBool isAgreed = false.obs;
  final RxString accountId = ''.obs;
  final RxDouble totalAmount = 32.999.obs;

  final String title = Get.arguments['title'];
  final String imageUrl = Get.arguments['image'];
  final String description = Get.arguments['description'] ?? 'No description available';  // Menambahkan pengecekan null
  final String price = Get.arguments['price'];

  @override
  void onInit() {
    super.onInit();
    _getAccountId();
  }

  void _getAccountId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      accountId.value = user.email ?? '';
    }
  }

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

    // Hapus game dari wishlist tanpa snackbar
    Get.find<WishlistController>().removeFromWishlist(title, showSnackbar: false);

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

    Future.delayed(const Duration(seconds: 2), () {
      Get.offAllNamed('/home');
    });
  }
}
