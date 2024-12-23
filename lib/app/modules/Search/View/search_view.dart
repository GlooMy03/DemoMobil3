// File: /lib/app/modules/Search/View/search_view.dart

import 'package:coba4/app/modules/Search/Controllers/game_search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchView extends StatelessWidget {
  final GameSearchController controller = Get.put(GameSearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0C28),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Search Games',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0E0C28),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: controller.searchTextController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: const Color(0xFF1C1B2E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: Obx(() => IconButton(
                      icon: Icon(
                        controller.isListening.value ? Icons.mic : Icons.mic_off,
                        color: Colors.white70,
                      ),
                      onPressed: () {
                        if (controller.isListening.value) {
                          controller.stopListening();
                        } else {
                          controller.startListening();
                        }
                      },
                    )),
              ),
              onChanged: controller.searchGame,
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.filteredGames.isEmpty) {
                return const Center(
                  child: Text(
                    'No games found.',
                    style: TextStyle(color: Colors.white70),
                  ),
                );
              }
              return ListView.builder(
                itemCount: controller.filteredGames.length,
                padding: const EdgeInsets.only(top: 16),
                itemBuilder: (context, index) {
                  var game = controller.filteredGames[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: GestureDetector(
                      onTap: () {
                        var price = game['price']; // Ambil harga dari game
                        print('Price: $price'); // Debug untuk melihat harga yang dikirim

                        // Pastikan jika harga ada, baru diteruskan
                        Get.toNamed('/game_detail', arguments: {
                          'title': game['title'],
                          'image': game['image'],
                          'description': game['description'],
                          'price': price ?? 'Unknown Price', // Mengirim harga atau default jika null
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C1B2E),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              game['image'],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            game['title'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            game['description'],
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
