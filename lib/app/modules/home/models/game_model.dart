// lib/app/models/game_model.dart
class GameModel {
  final String title;
  final String image;

  GameModel({required this.title, required this.image});

  // Bisa di-update jika data datang dari API
  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      title: json['title'],
      image: json['image'],
    );
  }
}
