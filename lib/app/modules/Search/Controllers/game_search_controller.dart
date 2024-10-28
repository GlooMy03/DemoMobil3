import 'package:get/get.dart';

class GameSearchController extends GetxController {
  final List<Map<String, String>> topSellers = [
    {'title': 'EA SPORTS FC 25', 'image': 'assets/images/spiderman.jpeg'},
    {'title': 'Counter-Strike 2', 'image': 'assets/images/spiderman.jpeg'},
    {'title': 'Black Myth: Wukong', 'image': 'assets/images/spiderman.jpeg'},
    {'title': 'Warhammer 40,000', 'image': 'assets/images/spiderman.jpeg'},
    {'title': 'DRAGON BALL: Sparking! ZERO', 'image': 'assets/images/spiderman.jpeg'},
    {'title': 'PUBG: BATTLEGROUNDS', 'image': 'assets/images/spiderman.jpeg'},
  ];

  List<Map<String, String>> filteredTopSellers = [];

  @override
  void onInit() {
    super.onInit();
    filteredTopSellers = topSellers; // Inisialisasi dengan semua game
  }

  void searchGame(String query) {
    if (query.isEmpty) {
      filteredTopSellers = topSellers; // Tampilkan semua jika pencarian kosong
    } else {
      filteredTopSellers = topSellers
          .where((game) => game['title']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    update(); // Notifikasi UI untuk update tampilan
  }
}