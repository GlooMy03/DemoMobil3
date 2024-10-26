import 'package:flutter/material.dart';
import '../models/game_model.dart';
import '../widgets/category_button.dart';
import '../widgets/game_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Game> games = [
      Game(title: 'Elden Ring', imageUrl: 'assets/images/elden_ring.png'),
      Game(title: 'Spider-Man 2', imageUrl: 'assets/images/spider_man.png'),
      Game(title: 'Ghost of Tsushima', imageUrl: 'assets/images/ghost_tsushima.png'),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CategoryButton(label: 'TOP SELLER'),
              CategoryButton(label: 'NEW RELEASE'),
              CategoryButton(label: 'SPECIAL OFFER'),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: games.length,
              itemBuilder: (context, index) {
                return GameCard(game: games[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
