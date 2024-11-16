import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeskListView extends StatelessWidget {
  const DeskListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A2A2A),
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        elevation: 0,
        title: Text(
          "Community Posts",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton<int>(
            onSelected: (value) {
              if (value == 0)
                Get.toNamed('/getconnect'); // Navigate to GetConnect page
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
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "No posts yet. Add one!",
                        style: TextStyle(color: Colors.white60),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.all(16.0),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot document = snapshot.data!.docs[index];
                      Map<String, dynamic> task =
                          document.data() as Map<String, dynamic>;

                      return Card(
                        color: Color(0xFF424242),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(
                            task['name'],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task['description'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.white70),
                              ),
                              if (task.containsKey('mediaUrl')) ...[
                                SizedBox(height: 8.0),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: task['mediaUrl'].endsWith('.mp4')
                                      ? Icon(Icons.video_library,
                                          color: Colors.blueAccent, size: 50)
                                      : Image.network(
                                          task['mediaUrl'],
                                          height: 150,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ],
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (String value) async {
                              if (value == 'edit') {
                                // Navigate to edit page
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
                              PopupMenuItem<String>(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              PopupMenuItem<String>(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                            child: Icon(Icons.more_vert, color: Colors.white),
                          ),
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
                  // Navigate to CreateTaskScreen
                  Get.toNamed('/createtaskscreen');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  'ADD POST',
                  style: TextStyle(
                    color: Colors.black,
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
