import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0E0C28),
      appBar: AppBar(
        backgroundColor: Color(0xFF0E0C28),
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile.jpg'), // Gambar avatar lokal
              radius: 18,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo Kelompok 4',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Apa Kabar?',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Get.toNamed('/search');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          _buildCategoryButtons(),
          SizedBox(height: 20),
          Expanded(
            child: Column(
              children: [
                _buildFeaturedGame(),
                SizedBox(height: 20),
                Expanded(child: _buildGameList()),
              ],
            ),
          ),
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
                ? Color(0xFF1C1B2E)
                : Color(0xFF29274C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () => controller.selectCategory(title),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ));
  }

  Widget _buildFeaturedGame() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: AssetImage('assets/images/minecraft.jpeg'), // Gambar game unggulan lokal
          fit: BoxFit.cover,
        ),
      ),
      height: 200,
    );
  }

  Widget _buildGameList() {
    return Obx(() {
      if (controller.games.isEmpty) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1EB980)),
          ),
        );
      }
      return GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 1.0,
        ),
        itemCount: controller.games.length,
        itemBuilder: (context, index) {
          var game = controller.games[index];
          return _buildGameCard(game.title, game.image, game.description);
        },
      );
    });
  }

  Widget _buildGameCard(String title, String imageUrl, String description) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/game_detail', arguments: {
          'title': title,
          'image': imageUrl,
          'description': description,
        });
      },
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/ghost.jpeg', // Gambar game lokal
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Color(0xFF1C1B2E),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {
              Get.toNamed("/storage");
            },
          ),
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Get.toNamed("/profile");
            },
          ),
          IconButton(
            icon: Icon(Icons.admin_panel_settings, color: Colors.white),
            onPressed: () {
              Get.toNamed("/admin");
            },
          ),
        ],
      ),
    );
  }
}
