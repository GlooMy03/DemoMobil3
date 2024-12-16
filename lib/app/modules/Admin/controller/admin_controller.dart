import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import '../../home/models/game_model.dart';

class AdminController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var games = <GameModel>[].obs;
  final GetStorage _storage = GetStorage(); // Inisialisasi GetStorage

  @override
  void onInit() {
    super.onInit();
    fetchGames();
  }

  // Fungsi untuk mengambil data game
  void fetchGames() async {
    try {
      final snapshot = await _firestore.collection('games').get();
      games.value = snapshot.docs
          .map((doc) => GameModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch games: $e');
    }
  }

  // Fungsi untuk menambahkan game
  Future<void> addGame(GameModel game) async {
    try {
      await _firestore.collection('games').add(game.toJson());
      fetchGames(); // Refresh games list
    } catch (e) {
      // Jika gagal, simpan data ke storage
      _storage.write('pending_game_data', game.toJson());
      Get.snackbar('Error', 'Failed to add game, saved locally: $e');
    }
  }

  // Fungsi untuk update game
  Future<void> updateGame(String id, GameModel game) async {
    try {
      await _firestore.collection('games').doc(id).update(game.toJson());
      fetchGames(); // Refresh games list
    } catch (e) {
      Get.snackbar('Error', 'Failed to update game: $e');
    }
  }

  // Fungsi untuk delete game
  Future<void> deleteGame(String id) async {
    try {
      await _firestore.collection('games').doc(id).delete();
      fetchGames(); // Refresh games list
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete game: $e');
    }
  }
}
