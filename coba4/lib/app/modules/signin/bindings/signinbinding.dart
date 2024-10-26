import 'package:get/get.dart';
import '../../signin/controllers/signincontroller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
