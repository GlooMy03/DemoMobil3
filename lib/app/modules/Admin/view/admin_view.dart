import 'package:coba4/app/modules/Admin/controller/admin_controller.dart';
import 'package:coba4/app/modules/home/models/game_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminView extends StatelessWidget {
  final AdminController controller = Get.find<AdminController>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input untuk title
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Game Title'),
            ),
            // Input untuk image URL
            TextField(
              controller: imageController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            // Input untuk description
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            // Tombol untuk menambahkan game baru
            ElevatedButton(
              onPressed: () {
                final game = GameModel(
                  id: '', // ID akan di-generate otomatis oleh Firebase
                  title: titleController.text,
                  image: imageController.text,
                  description: descriptionController.text, // Tambahkan deskripsi
                );
                controller.addGame(game);
                titleController.clear();
                imageController.clear();
                descriptionController.clear();
              },
              child: Text('Add Game'),
            ),
            SizedBox(height: 20),
            // Daftar game yang ada
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: controller.games.length,
                    itemBuilder: (context, index) {
                      final game = controller.games[index];
                      return ListTile(
                        title: Text(game.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(game.image),
                            Text(game.description), // Tampilkan deskripsi
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Tombol edit
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
                                          decoration:
                                              InputDecoration(labelText: 'Game Title'),
                                        ),
                                        TextField(
                                          controller: imageController,
                                          decoration:
                                              InputDecoration(labelText: 'Image URL'),
                                        ),
                                        TextField(
                                          controller: descriptionController,
                                          decoration:
                                              InputDecoration(labelText: 'Description'),
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
                            // Tombol delete
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
