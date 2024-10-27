// lib/app/services/game_service.dart
import '../models/game_model.dart';

class GameService {
  // Mengambil data statis dari game; nanti bisa diganti dengan panggilan API.
  Future<List<GameModel>> fetchGames() async {
    // Simulasi delay jaringan
    await Future.delayed(Duration(seconds: 2));

    return [
      GameModel(title: 'Spider-Man 2', image: 'assets/images/spiderman.jpeg'),
      GameModel(title: 'Ghost of Tsushima', image: 'assets/images/ghost.jpeg'),
      // Tambahkan game lain di sini jika diperlukan
    ];
  }
}
