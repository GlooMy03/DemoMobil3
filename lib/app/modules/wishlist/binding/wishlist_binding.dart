import 'package:coba4/app/modules/wishlist/controller/wishlist_controller.dart';
import 'package:get/get.dart';

class WishlistBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<WishlistController>(WishlistController(), permanent: true);
  }
}
