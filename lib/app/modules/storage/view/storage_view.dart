import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class StorageViewer extends StatelessWidget {
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stored Data"),
      ),
      body: FutureBuilder(
        future: box.read('pending_game'), // Ambil data yang tersimpan
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Center(child: Text("No data stored"));
          }

          var storedData = snapshot.data;
          return ListView(
            children: [
              ListTile(
                title: Text("Stored Game Data"),
                subtitle: Text(storedData.toString()), // Menampilkan data game
              ),
            ],
          );
        },
      ),
    );
  }
}
