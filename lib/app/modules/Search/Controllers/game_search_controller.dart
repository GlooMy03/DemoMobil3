import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/material.dart';

class GameSearchController extends GetxController {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final TextEditingController searchTextController = TextEditingController();

  var isListening = false.obs;
  var text = "".obs;
  var filteredTopSellers = <Map<String, String>>[].obs;

  final List<Map<String, String>> topSellers = [
    {'title': 'EA SPORTS FC 25', 'image': 'assets/images/spiderman.jpeg'},
    {'title': 'Counter-Strike 2', 'image': 'assets/images/spiderman.jpeg'},
    {'title': 'Black Myth: Wukong', 'image': 'assets/images/spiderman.jpeg'},
    {'title': 'Warhammer 40,000', 'image': 'assets/images/spiderman.jpeg'},
    {'title': 'DRAGON BALL: Sparking! ZERO', 'image': 'assets/images/spiderman.jpeg'},
    {'title': 'PUBG: BATTLEGROUNDS', 'image': 'assets/images/spiderman.jpeg'},
  ];

  @override
  void onInit() {
    super.onInit();
    filteredTopSellers.value = topSellers;
    _initSpeech();

    // Listener untuk text field
    searchTextController.addListener(() {
      searchGame(searchTextController.text);
    });
  }

  void _initSpeech() async {
    try {
      await _speech.initialize();
    } catch (e) {
      print(e);
    }
  }

  Future<void> checkMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }

  void searchGame(String query) {
    if (query.isEmpty) {
      filteredTopSellers.value = topSellers;
    } else {
      filteredTopSellers.value = topSellers
          .where((game) => game['title']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    update(); // Memperbarui tampilan
  }

  void startListening() async {
    await checkMicrophonePermission();
    if (await Permission.microphone.isGranted) {
      isListening.value = true;
      await _speech.listen(onResult: (result) {
        text.value = result.recognizedWords;
        searchTextController.text = result.recognizedWords; // Update search bar text
      });
    } else {
      print("Izin mikrofon ditolak.");
    }
  }

  void stopListening() async {
    isListening.value = false;
    await _speech.stop();
  }
}
