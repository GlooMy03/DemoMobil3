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
        title: GestureDetector(
          onTap: () {
            Get.toNamed('/about');
          },
          child: Text(
            'GAMENET',
            style: TextStyle(color: Colors.teal),
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
          _buildCategoryButtons(),
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
    return Obx(() {
      if (controller.games.isEmpty) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
          ),
        );
      }
      return GridView.builder(
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
        'description': description,  // Pastikan description dikirim
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
        color: Colors.grey[850],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.home, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {},
          ),
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
