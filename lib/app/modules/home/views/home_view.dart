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
        title: GestureDetector(
  onTap: () {
    // Ganti dengan nama route halaman yang ingin dituju
        Get.toNamed('/about');
      },
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent, // Optional: Makes the background transparent
            radius: 18,
            child: Icon(
              Icons.gamepad, // Replace with your desired icon
              color: Colors.white, // Color of the icon
              size: 24, // Adjust the icon size
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'GAMENET',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Toko Game Murah',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
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
          return _buildGameCard(game.title, game.image, game.description, game.price);
        },
      );
    });
  }

  Widget _buildGameCard(String title, String imageUrl, String description, String price) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/game_detail', arguments: {
          'title': title,
          'image': imageUrl,
          'description': description,
          'price': price,
        });
      },
      child: Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                  ),
                );
              },
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
          style: TextStyle(color: Colors.white),
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
              Get.toNamed("/wishlist");
            },
          ),
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Get.toNamed("/profile");
            },
          ),
        ],
      ),
    );
  }
}
