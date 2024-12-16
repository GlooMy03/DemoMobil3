// lib/app/services/game_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/game_model.dart';

class GameService {
  // Mengambil data dari Firestore secara real-time menggunakan stream
  Stream<List<GameModel>> fetchGames() {
    return FirebaseFirestore.instance
        .collection('games')
        .snapshots()  // Menggunakan snapshots() untuk mendapatkan update real-time
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => GameModel.fromJson(doc.data(), doc.id))
              .toList();
        });
  }
}