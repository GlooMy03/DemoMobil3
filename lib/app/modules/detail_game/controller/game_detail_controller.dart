import 'package:get/get.dart';

class GameDetailController extends GetxController {
  // Game data passed from HomeView
  final String title = Get.arguments['title'];
  final String imageUrl = Get.arguments['image'];
  final String description = Get.arguments['description'] ?? 'No description available';  // Menambahkan pengecekan null
}
