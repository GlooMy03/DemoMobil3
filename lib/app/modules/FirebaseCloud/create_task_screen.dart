import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:coba4/app/modules/FirebaseCloud/app_color.dart';

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
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final AppColor appColor = AppColor();
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();
  bool isLoading = false;
  File? selectedMediaFile;
  String? mediaUrl;

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
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.isEdit ? 'Edit Community Post' : 'Create New Post',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(),
                SizedBox(height: 24.0),
                _buildFormSection(),
                SizedBox(height: 24.0),
                if (selectedMediaFile != null) _buildMediaPreview(),
                if (isLoading)
                  _buildLoadingIndicator()
                else
                  _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: appColor.colorTertiary,
            child: Icon(Icons.person, color: Colors.white),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Text(
              'Share with the Community',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey[700]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            controller: controllerName,
            label: 'Title',
            icon: Icons.title,
            maxLines: 1,
          ),
          SizedBox(height: 20.0),
          _buildTextField(
            controller: controllerDescription,
            label: 'Description',
            icon: Icons.description,
            maxLines: 5,
            showMediaButtons: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    bool showMediaButtons = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(icon, color: Colors.grey[400]),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey[600]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: appColor.colorTertiary),
            ),
            filled: true,
            fillColor: Colors.grey[800],
          ),
        ),
        if (showMediaButtons) ...[
          SizedBox(height: 8.0),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.camera_alt, color: appColor.colorTertiary),
                onPressed: () async => _pickMedia(isVideo: false),
              ),
              IconButton(
                icon: Icon(Icons.videocam, color: appColor.colorTertiary),
                onPressed: () async => _pickMedia(isVideo: true),
              ),
              IconButton(
                icon: Icon(Icons.photo_library, color: appColor.colorTertiary),
                onPressed: () async => _pickMediaFromGallery(),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildMediaPreview() {
    return Column(
      children: [
        Text('Selected Media:', style: TextStyle(color: Colors.white)),
        SizedBox(height: 8.0),
        if (selectedMediaFile!.path.contains('.mp4'))
          Icon(Icons.video_library, size: 50, color: Colors.white)
        else
          Image.file(selectedMediaFile!, height: 100, width: 100),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(appColor.colorTertiary),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 50.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: appColor.colorTertiary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          widget.isEdit ? 'UPDATE POST' : 'PUBLISH POST',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: _handleSubmit,
      ),
    );
  }

  Future<void> _pickMedia({required bool isVideo}) async {
    final picker = ImagePicker();
    XFile? pickedFile;

    try {
      pickedFile = isVideo
          ? await picker.pickVideo(source: ImageSource.camera)
          : await picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        setState(() {
          selectedMediaFile = File(pickedFile!.path);
        });
      }
    } catch (e) {
      _showSnackBarMessage('Error capturing media: $e');
    }
  }

  Future<void> _pickMediaFromGallery() async {
    final picker = ImagePicker();
    XFile? pickedFile;

    try {
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          selectedMediaFile = File(pickedFile!.path);
        });
      }
    } catch (e) {
      _showSnackBarMessage('Error picking media: $e');
    }
  }

  Future<void> _uploadMedia() async {
    if (selectedMediaFile == null) return;

    final String fileName = selectedMediaFile!.path.split('/').last;
    final Reference storageRef = storage.ref().child('uploads/$fileName');

    try {
      UploadTask uploadTask = storageRef.putFile(selectedMediaFile!);
      TaskSnapshot snapshot = await uploadTask;
      mediaUrl = await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload media: $e');
    }
  }

  Future<void> _handleSubmit() async {
    String name = controllerName.text;
    String description = controllerDescription.text;

    if (name.isEmpty || description.isEmpty) {
      _showSnackBarMessage('Title and description are required');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      if (selectedMediaFile != null) {
        await _uploadMedia();
      }

      if (widget.isEdit) {
        await firestore.collection('tasks').doc(widget.documentId).update({
          'name': name,
          'description': description,
          if (mediaUrl != null) 'mediaUrl': mediaUrl,
        });
      } else {
        await firestore.collection('tasks').add({
          'name': name,
          'description': description,
          if (mediaUrl != null) 'mediaUrl': mediaUrl,
        });
      }

      Navigator.pop(context);
    } catch (e) {
      _showSnackBarMessage('Error saving post: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showSnackBarMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
