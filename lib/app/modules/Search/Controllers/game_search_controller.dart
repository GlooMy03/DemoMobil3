import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GameSearchController extends GetxController {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final TextEditingController searchTextController = TextEditingController();
  
  var isListening = false.obs;
  var text = "".obs;
  var filteredGames = <Map<String, dynamic>>[].obs;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    _initSpeech();
    fetchAllGames();
    searchTextController.addListener(() {
      searchGame(searchTextController.text);
    });
  }

  void _initSpeech() async {
    try {
      await _speech.initialize();
    } catch (e) {
      print("Speech-to-Text initialization error: $e");
    }
  }

  Future<void> checkMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }

  void fetchAllGames() async {
    try {
      final allGames = await firestore.collection('games').get();
      if (allGames.docs.isNotEmpty) {
        filteredGames.value = allGames.docs.map((doc) {
          var data = doc.data();
          return {
            'title': data['title'] ?? 'No Title',
            'description': data['description'] ?? 'No description available.',
            'image': data['image'] ?? 'assets/images/default_game.png',
          };
        }).toList();
      } else {
        print('No games found in the Firestore collection.');
      }
    } catch (e) {
      print("Error fetching all games: $e");
      filteredGames.clear();
    }
  }

  void searchGame(String query) async {
    if (query.isEmpty) {
      fetchAllGames();
    } else {
      try {
        final gameQuery = await firestore
            .collection('games')
            .where('title', isGreaterThanOrEqualTo: query)
            .where('title', isLessThanOrEqualTo: query + '\uf8ff')
            .get();

        if (gameQuery.docs.isNotEmpty) {
          filteredGames.value = gameQuery.docs.map((doc) {
            var data = doc.data();
            return {
              'title': data['title'] ?? 'No Title',
              'description': data['description'] ?? 'No description available.',
              'image': data['image'] ?? 'assets/images/default_game.png',
            };
          }).toList();
        } else {
          print("No games found for the search query.");
          filteredGames.clear(); // Clear the list if no matches
        }
      } catch (e) {
        print("Error fetching games: $e");
        filteredGames.clear();
      }
    }
  }

  void startListening() async {
    await checkMicrophonePermission();
    if (await Permission.microphone.isGranted) {
      isListening.value = true;
      await _speech.listen(onResult: (result) {
        text.value = result.recognizedWords;
        searchTextController.text = result.recognizedWords;
      });
    } else {
      print("Microphone permission denied.");
    }
  }

  void stopListening() async {
    isListening.value = false;
    await _speech.stop();
  }
}
