// File 4: /lib/app/modules/wishlist/controller/wishlist_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class WishlistController extends GetxController {
  var wishlist = <Map<String, dynamic>>[].obs; // Ubah menjadi dynamic
  var accountId = ''.obs; // Menyimpan email pengguna atau ID akun
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    _getAccountId();
  }

  // Mendapatkan ID akun (email) dari FirebaseAuth
  void _getAccountId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      accountId.value = user.email ?? '';
      fetchWishlist(); // Panggil fetchWishlist setelah mendapatkan accountId
    }
  }

  // Fetch wishlist dari Firestore
  void fetchWishlist() async {
    if (accountId.isEmpty) return;

    final userWishlist = await firestore
        .collection('users')
        .doc(accountId.value)
        .collection('wishlist')
        .get();

    wishlist.value = userWishlist.docs.map((doc) {
      return doc.data(); // Tidak perlu casting manual, gunakan dynamic
    }).toList();
  }

  // Menambahkan item ke wishlist
  void addToWishlist(Map<String, dynamic> game) async {
    if (accountId.isEmpty) return;

    // Cek apakah game sudah ada di wishlist
    bool gameExists = wishlist.any((item) => item['title'] == game['title']);
    
    if (!gameExists) {
      // Simpan game ke Firestore jika belum ada
      await firestore
          .collection('users')
          .doc(accountId.value)
          .collection('wishlist')
          .doc(game['title'])
          .set(game);

      wishlist.add(game);
      Get.snackbar(
        "Wishlist",
        "${game['title']} has been added to your wishlist!",
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        "Wishlist",
        "${game['title']} is already in your wishlist!",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Menghapus item dari wishlist tanpa menampilkan snackbar setelah membeli game
  void removeFromWishlist(String title, {bool showSnackbar = true}) async {
    if (accountId.isEmpty) return;

    // Hapus game dari Firestore
    await firestore
        .collection('users')
        .doc(accountId.value)
        .collection('wishlist')
        .doc(title)
        .delete();

    wishlist.removeWhere((game) => game['title'] == title);

    if (showSnackbar) {
      Get.snackbar(
        "Wishlist",
        "$title has been removed from your wishlist!",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
