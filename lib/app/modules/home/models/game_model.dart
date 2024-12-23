class GameModel {
  final String id;
  final String title;
  final String image;
  final String description;
  final String price;

  GameModel({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    required this.price,
  });

  // Factory method to create an instance of GameModel from Firestore JSON
  factory GameModel.fromJson(Map<String, dynamic> json, String id) {
    return GameModel(
      id: id,
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '',
    );
  }

  // Method to convert GameModel to JSON (for saving to Firestore)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'image': image,
      'description': description,
      'price': price,
    };
  }
}
