import 'package:coba4/app/modules/detail_game/controller/game_detail_controller.dart';
import 'package:coba4/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameDetailView extends StatelessWidget {
  final GameDetailController controller = Get.find<GameDetailController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1228), // Warna latar belakang utama
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1228), // Warna latar belakang AppBar
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.lock_outline, color: Colors.white),
            onPressed: () {
              // Aksi untuk ikon lock
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display Game Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                controller.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white), // Warna loading
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                      size: 100,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Display Game Title
            Text(
              controller.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Display Game Description
            Text(
              controller.description,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            // Buttons
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/buy');// Aksi untuk tombol Buy
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD32F2F), // Warna tombol
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'BUY',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/desklist');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD32F2F), // Warna tombol
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Community',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
