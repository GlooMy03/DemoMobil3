import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coba4/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeskListView extends StatelessWidget {
  const DeskListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A2A2A),
      appBar: AppBar(
        title: Text("Community"),
        actions: [
          PopupMenuButton<int>(
            onSelected: (value) {
              switch (value) {
                case 0:
                  Get.toNamed(Routes.GETCONNECT);
                  break;
              }
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
      body: Column(
        children: [
          // Todo list section
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    Map<String, dynamic> task = document.data() as Map<String, dynamic>;

                    return Card(
                      color: Color(0xFF424242),
                      child: ListTile(
                        title: Text(
                          task['name'],
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          task['description'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white60),
                        ),
                        leading: Icon(
                          Icons.task,
                          color: Colors.blueAccent,
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (String value) async {
                            if (value == 'edit') {
                              // Add edit feature here
                            } else if (value == 'delete') {
                              await FirebaseFirestore.instance
                                  .collection('tasks')
                                  .doc(document.id)
                                  .delete();
                            }
                          },
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
                // Navigate to CreateTaskScreen, assuming GetX is used for navigation
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
                'ADD TASK',
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
    );
  }
}
