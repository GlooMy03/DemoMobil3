import 'package:coba4/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import the AppRoutes to access SIGN_IN constant

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgroundlandingpage.png', // Tambahkan path gambar di sini
              fit: BoxFit.cover,
            ),
          ),
          // "GAMENET" Text
          Positioned(
            top: 300,
            child: Text(
              'GAMENET',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.cyanAccent,
              ),
            ),
          ),
          // Additional Layer (e.g., Player and Ball)
          // Positioned(
          //   bottom: 100,
          //   child: Opacity(
          //     opacity: 0.8,
          //     child: Image.asset(
          //       'assets/images/backgroundlandingpage.png', // Tambahkan path gambar di sini
          //       width: 300,
          //     ),
          //   ),
          // ),
          // Tombol Navigasi dengan Get.toNamed
          Positioned(
            bottom: 50,
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.SIGNIN); // Arahkan ke SIGN_IN route
              },
              child: Text('Next Page'),
            ),
          ),
        ],
      ),
    );
  }
}
