import 'package:coba4/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E2A), // Warna background utama (biru gelap)
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Ikon "GameNET"
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4, // Posisi vertikal di tengah atas
            child: Column(
              children: [
                // Logo "GameNET"
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Game',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'NET',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF50C2C9), // Warna cyan
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Tombol "Get Started"
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.1, // Posisi tombol
            child: SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 172, 126, 201), // Warna tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Get.toNamed(Routes.LOGIN); // Navigasi ke halaman berikutnya
                },
                child: Text(
                  'Get Started',
                  style: TextStyle(
                    color: Colors.black, // Warna teks
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
