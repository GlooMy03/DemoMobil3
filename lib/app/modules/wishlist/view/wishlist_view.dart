import 'package:coba4/app/modules/wishlist/controller/wishlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishlistView extends StatelessWidget {
  final WishlistController controller = Get.find<WishlistController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1228),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1228),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "My Wishlist",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Obx(() {
        print("Wishlist length: ${controller.wishlist.length}");
        if (controller.wishlist.isEmpty) {
          return const Center(
            child: Text(
              "Your wishlist is empty.",
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.wishlist.length,
          itemBuilder: (context, index) {
            final game = controller.wishlist[index];
            return Card(
              color: const Color(0xFF1C1B2E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: Image.network(
                  game['image'] ?? '',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  game['title'] ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '\Rp. ${game['price'] ?? ''}',
                  style: const TextStyle(color: Colors.grey),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        controller.removeFromWishlist(game['title'] ?? '');
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.shopping_cart, color: Colors.green),
                      onPressed: () {
                        // Arahkan ke halaman pembelian dengan data game yang sesuai
                        Get.toNamed('/buy', arguments: game);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
