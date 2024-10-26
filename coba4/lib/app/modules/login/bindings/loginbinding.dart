import 'package:get/get.dart';
import '../../signin/controllers/signincontroller.dart';

class loginbinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
