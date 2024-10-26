import 'package:flutter/material.dart';
import '../models/game_model.dart';

class GameDetailScreen extends StatelessWidget {
  const GameDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil data game dari argument yang dikirim saat navigasi
    final Game game = ModalRoute.of(context)!.settings.arguments as Game;

    return Scaffold(
      appBar: AppBar(
        title: Text(game.title),
      ),
      body: Center(
        child: Column(
          children: [
            Image.asset(game.imageUrl),
            const SizedBox(height: 20),
            Text(
              game.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
