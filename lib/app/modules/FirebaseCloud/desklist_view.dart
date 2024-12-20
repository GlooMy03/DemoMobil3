import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeskListView extends StatelessWidget {
  const DeskListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1228), // Warna latar belakang utama
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1228),
        elevation: 0,
        title: const Text(
          "Community",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          PopupMenuButton<int>(
            onSelected: (value) {
              if (value == 0) Get.toNamed('/getconnect');
            },
            itemBuilder: (context) => [
              const PopupMenuItem<int>(
                value: 0,
                child: Text("Article Game"),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // List of tasks
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('tasks').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(color: Colors.white));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No posts yet. Add one!",
                        style: TextStyle(color: Colors.white60),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot document = snapshot.data!.docs[index];
                      Map<String, dynamic> task =
                          document.data() as Map<String, dynamic>;

                      return Card(
                        color: const Color(0xFF1F2A46), // Warna kartu
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(
                                task['name'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                "Description: ${task['description']}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white70),
                              ),
                              trailing: PopupMenuButton<String>(
                                onSelected: (String value) async {
                                  if (value == 'edit') {
                                    Get.toNamed('/createtaskscreen', arguments: {
                                      'isEdit': true,
                                      'documentId': document.id,
                                      'name': task['name'],
                                      'description': task['description'],
                                      'mediaUrl': task['mediaUrl'] ?? '',
                                    });
                                  } else if (value == 'delete') {
                                    await FirebaseFirestore.instance
                                        .collection('tasks')
                                        .doc(document.id)
                                        .delete();
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                  const PopupMenuItem<String>(
                                    value: 'edit',
                                    child: Text('Edit'),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Text('Delete'),
                                  ),
                                ],
                                child: const Icon(Icons.more_vert,
                                    color: Colors.white),
                              ),
                            ),
                            if (task['mediaUrl'] != null &&
                                task['mediaUrl'].isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: task['mediaType'] == 'video'
                                      ? Container(
                                          color: Colors.black54,
                                          height: 200,
                                          child: const Center(
                                            child: Icon(Icons.videocam,
                                                color: Colors.white, size: 40),
                                          ),
                                        )
                                      : Image.network(
                                          task['mediaUrl'],
                                          height: 200,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            // Button to add new task
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed('/createtaskscreen');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD32F2F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'ADD POST',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
