import 'package:coba4/app/modules/Search/Controllers/game_search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchView extends StatelessWidget {
  final GameSearchController controller = Get.put(GameSearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'SEARCH',
          style: TextStyle(color: const Color.fromARGB(255, 108, 202, 245)),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Search Bar with Mic
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: controller.searchTextController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search game...',
                    hintStyle: TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) => controller.searchGame(value),
                ),
                Obx(
                  () => IconButton(
                    icon: Icon(
                      controller.isListening.value ? Icons.mic : Icons.mic_none,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (controller.isListening.value) {
                        controller.stopListening();
                      } else {
                        controller.startListening();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 0, 0, 0),
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'TOP SELLER',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Expanded(
            child: GetBuilder<GameSearchController>(
              builder: (_) {
                return ListView.builder(
                  itemCount: controller.filteredTopSellers.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            child: Image.asset(
                              controller.filteredTopSellers[index]['image']!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              controller.filteredTopSellers[index]['title']!,
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              // Tambahkan aksi yang kamu inginkan di sini
                            },
                          ),
                        ],
                      ),
                      color: const Color.fromARGB(255, 31, 30, 30),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
