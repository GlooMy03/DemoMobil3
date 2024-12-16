import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/game_model.dart';
import '../services/game_service.dart';

class HomeController extends GetxController {
  final GameService _gameService = GameService();

  // Daftar game sebagai observable
  var games = <GameModel>[].obs;
  var selectedCategory = 'Top Seller'.obs;

  @override
  void onInit() {
    super.onInit();
    // Menggunakan stream dari GameService untuk update data secara real-time
    _gameService.fetchGames().listen((newGames) {
      games.value = newGames; // Update observable games
    });
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }
}

void loadGames(dynamic games) async {
  final snapshot = await FirebaseFirestore.instance.collection('games').get();
  games.value = snapshot.docs
      .map((doc) => GameModel.fromJson(doc.data(), doc.id)) // Tambahkan doc.id sebagai argumen kedua
      .toList();
}
