import 'package:coba4/app/modules/detail_game/controller/game_detail_controller.dart';
import 'package:coba4/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameDetailView extends StatelessWidget {
  final GameDetailController controller = Get.find<GameDetailController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Game Detail',
          style: TextStyle(color: Colors.teal),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display Game Image
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  controller.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 100,
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            // Display Game Title
            Text(
              controller.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            // Display Game Description
            Text(
              controller.description,  // Menampilkan description dari controller
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),


            SizedBox(height: 20),
            // Add a button to navigate to another page
            ElevatedButton(
              onPressed: () {
                // Ganti '/some_other_page' dengan route tujuan Anda
                Get.toNamed('/desklist');

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Button color
              ),
              child: Text(
                'Community Center',
                style: TextStyle(color: Colors.white),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
