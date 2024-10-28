import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'GAMENET',
          style: TextStyle(color: Colors.teal),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryButtons(),
          SizedBox(height: 20),
          // Main image button at the top center
          Center(
            child: GestureDetector(
              onTap: () {
                Get.toNamed("/desk");
                // Implement the action for main image button tap
              },
              child: SizedBox(
                width: 200, // Adjust width as needed
                height: 250, // Adjust height as needed
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/eldenring.jpeg', // Replace with your image path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(child: _buildGameList()),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildCategoryButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _categoryButton('Top Seller'),
        SizedBox(width: 10),
        _categoryButton('New Release'),
        SizedBox(width: 10),
        _categoryButton('Special Offer'),
      ],
    );
  }

  Widget _categoryButton(String title) {
    return Obx(() => ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: controller.selectedCategory.value == title
                ? Colors.teal
                : Colors.grey[800],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () => controller.selectCategory(title),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(color: Colors.white),
          ),
        ));
  }

  Widget _buildGameList() {
    return Obx(() => GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 1.0,
          ),
          itemCount: controller.games.length,
          itemBuilder: (context, index) {
            var game = controller.games[index];
            return _buildGameCard(game.title, game.image);
          },
        ));
  }

  Widget _buildGameCard(String title, String imagePath) {
    return GestureDetector(
      onTap: () {
        // Implement action when game card is tapped
      },
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
          ),
          SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[850],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.home, color: Colors.white),
            onPressed: () {
              // Home button action
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {
              // Wishlist button action
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {
              // Shopping button action
            },
          ),
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: () {
              // Notification button action
            },
          ),
        ],
      ),
    );
  }
}
