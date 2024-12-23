import 'package:coba4/app/modules/Admin/controller/admin_controller.dart';
import 'package:coba4/app/modules/home/models/game_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminView extends StatelessWidget {
  final AdminController controller = Get.find<AdminController>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF0F1324), // Warna background AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        color: Color(0xFF0F1324), // Warna background utama
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF2D55), // Warna tombol Tambahkan Game
                ),
                child: Text('Tambahkan Game', style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF1C1A33), // Background container form
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Color(0xFF0F1324), // Background TextField
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: imageController,
                    decoration: InputDecoration(
                      labelText: 'Image URL',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Color(0xFF0F1324), // Background TextField
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Color(0xFF0F1324), // Background TextField
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    maxLines: 3,
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: priceController,
                    decoration: InputDecoration(
                      labelText: 'Price',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Color(0xFF0F1324), // Background TextField
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),

                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final game = GameModel(
                  id: '', // ID akan di-generate otomatis oleh Firebase
                  title: titleController.text,
                  image: imageController.text,
                  description: descriptionController.text, // Tambahkan deskripsi
                  price: priceController.text,
                );
                controller.addGame(game);
                titleController.clear();
                imageController.clear();
                descriptionController.clear();
                priceController.clear();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF2D55), // Warna tombol Add Game
              ),
              child: Text('Add Game', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: controller.games.length,
                    itemBuilder: (context, index) {
                      final game = controller.games[index];
                      return ListTile(
                        title: Text(game.title, style: TextStyle(color: Colors.white)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(game.image, style: TextStyle(color: Colors.white70)),
                            Text(game.description, style: TextStyle(color: Colors.white70)), // Tampilkan deskripsi
                            Text(game.price, style: TextStyle(color: Colors.white70)), // Tampilkan price
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.orange),
                              onPressed: () {
                                titleController.text = game.title;
                                imageController.text = game.image;
                                descriptionController.text = game.description;
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Update Game'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: titleController,
                                          decoration: InputDecoration(
                                              labelText: 'Game Title'),
                                        ),
                                        TextField(
                                          controller: imageController,
                                          decoration: InputDecoration(
                                              labelText: 'Image URL'),
                                        ),
                                        TextField(
                                          controller: descriptionController,
                                          decoration: InputDecoration(
                                              labelText: 'Description'),
                                          maxLines: 3,
                                        ),
                                        TextField(
                                          controller: priceController,
                                          decoration: InputDecoration(
                                              labelText: 'Price'),
                                          maxLines: 3,
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          controller.updateGame(
                                            game.id,
                                            GameModel(
                                              id: game.id,
                                              title: titleController.text,
                                              image: imageController.text,
                                              description: descriptionController.text,
                                              price: priceController.text,
                                            ),
                                          );
                                          Navigator.pop(context);
                                        },
                                        child: Text('Update'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                controller.deleteGame(game.id);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
