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
    loadGames();
  }

  void loadGames() async {
    // Memanggil fetchGames dan mengupdate observable games
    games.value = await _gameService.fetchGames();
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }
}
