import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coba4/app/modules/FirebaseCloud/app_color.dart';
import 'package:coba4/app/modules/FirebaseCloud/widget_background.dart';
import 'package:flutter/material.dart';

class CreateTaskScreen extends StatefulWidget {
  final bool isEdit;
  final String documentId;
  final String name;
  final String description;

  CreateTaskScreen({
    required this.isEdit,
    this.documentId = '',
    this.name = '',
    this.description = '',
  });

  @override
  _CreateTaskScreenState createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final AppColor appColor = AppColor();
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      controllerName.text = widget.name;
      controllerDescription.text = widget.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double widthScreen = mediaQueryData.size.width;
    double heightScreen = mediaQueryData.size.height;

    return Scaffold(
      key: scaffoldState,
      backgroundColor: appColor.colorPrimary,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            WidgetBackground(),
            Container(
              width: widthScreen,
              height: heightScreen,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildWidgetFormPrimary(),
                  SizedBox(height: 16.0),
                  _buildWidgetFormSecondary(),
                  isLoading
                      ? Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  appColor.colorTertiary),
                            ),
                          ),
                        )
                      : _buildWidgetButtonCreateTask(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetFormPrimary() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            widget.isEdit ? 'Edit\nTask' : 'Create\nNew Task',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[800],
                ),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: controllerName,
            decoration: InputDecoration(
              labelText: 'Name',
            ),
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetFormSecondary() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: controllerDescription,
              decoration: InputDecoration(
                labelText: 'Description',
                suffixIcon: Icon(Icons.description),
              ),
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetButtonCreateTask() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: appColor.colorTertiary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        child: Text(widget.isEdit ? 'UPDATE TASK' : 'CREATE TASK'),
        onPressed: () async {
          String name = controllerName.text;
          String description = controllerDescription.text;

          if (name.isEmpty) {
            _showSnackBarMessage('Name is required');
            return;
          } else if (description.isEmpty) {
            _showSnackBarMessage('Description is required');
            return;
          }
          setState(() => isLoading = true);

          if (widget.isEdit) {
            DocumentReference documentTask =
                firestore.collection('tasks').doc(widget.documentId);
            await firestore.runTransaction((transaction) async {
              DocumentSnapshot task = await transaction.get(documentTask);
              if (task.exists) {
                await transaction.update(
                  documentTask,
                  <String, dynamic>{
                    'name': name,
                    'description': description,
                  },
                );
                Navigator.pop(context, true);
              }
            });
          } else {
            CollectionReference tasks = firestore.collection('tasks');
            DocumentReference result = await tasks.add(<String, dynamic>{
              'name': name,
              'description': description,
            });
            if (result.id.isNotEmpty) {
              Navigator.pop(context, true);
            }
          }
          setState(() => isLoading = false);
        },
      ),
    );
  }

  void _showSnackBarMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
