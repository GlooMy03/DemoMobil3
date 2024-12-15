import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coba4/app/modules/AudioPlayer/controller/notifikasi_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:coba4/app/modules/FirebaseCloud/app_color.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get_storage/get_storage.dart';

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
  final GetStorage _storage = GetStorage(); // Penyimpanan lokal
  String? selectedAudio; // Variabel untuk menyimpan suara yang dipilih

  // final NotificationController notificationController =
  //     Get.put(NotificationController());
  // Pemutar audio

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      controllerName.text = widget.name;
      controllerDescription.text = widget.description;
    }
    _uploadLocalDataIfNeeded();
  }

  // Cek Koneksi Internet
  Future<bool> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Simpan Data Secara Lokal jika Tidak Ada Koneksi
  Future<void> _saveDataLocally(String name, String description) async {
    Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'mediaUrl': mediaUrl ?? '',
      'selectedAudio': selectedAudio ?? '',
    };
    await _storage.write('task_data', data);
    _showSnackBarMessage('Data disimpan secara lokal');
  }

  // Upload Data Lokal Saat Koneksi Tersedia
  Future<void> _uploadLocalDataIfNeeded() async {
    bool isConnected = await _checkInternetConnection();
    if (isConnected) {
      var localData = _storage.read('task_data');
      if (localData != null) {
        await _handleSubmit(); // Upload data lokal
        await _storage
            .remove('task_data'); // Hapus data lokal setelah berhasil diupload
      }
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
              IconButton(
                icon: Icon(Icons.audio_file, color: appColor.colorTertiary),
                onPressed: () async {
                  await _showAudioSelectionDialog();
                },
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
        onPressed: () async {
          await _handleSubmit();
          if (selectedAudio != null) {
            await _playNotificationSound(
                selectedAudio!); // Mainkan suara terpilih
          } else {
            _showSnackBarMessage(
                'Silakan pilih suara notifikasi terlebih dahulu!');
          }
        },
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

    bool isConnected = await _checkInternetConnection();

    if (isConnected) {
      try {
        // Simpan ke Firestore
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
      }
    } else {
      await _saveDataLocally(
          name, description); // Simpan secara lokal jika tidak terkoneksi
    }

    setState(() {
      isLoading = false;
    });
  }

  void _showSnackBarMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> _showAudioSelectionDialog() async {
    final List<String> audioOptions = [
      'Ting-sound.mp3',
      'notif2.mp3',
      'notif3.mp3',
    ]; // Daftar file suara

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Suara Notifikasi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: audioOptions.map((audio) {
              return RadioListTile<String>(
                title:
                    Text(audio.replaceAll('.mp3', '')), // Tampilkan nama suara
                value: audio,
                groupValue: selectedAudio,
                onChanged: (value) {
                  setState(() {
                    selectedAudio = value; // Simpan suara yang dipilih
                  });
                  Navigator.of(context).pop(); // Tutup dialog setelah memilih
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> _playNotificationSound(String audioName) async {
    final audioPlayer = AudioPlayer();
    final audioPath = 'audio/$audioName'; // Path file lokal

    try {
      await audioPlayer.play(AssetSource(audioPath));
    } catch (e) {
      _showSnackBarMessage('Failed to play sound: $e');
    }
  }

// Contoh penggunaan:
  void playTingSound() {
    _playNotificationSound('Ting-sound.mp3'); // Memutar Ting-sound.mp3
  }

  void playAlertSound() {
    _playNotificationSound(
        'Immersive-ocean-soundscapes.mp3'); // Memutar Alert-sound.mp3
  }

// void playErrorSound() {
//   _playNotificationSound('Error-sound.mp3'); // Memutar Error-sound.mp3
// }
}
