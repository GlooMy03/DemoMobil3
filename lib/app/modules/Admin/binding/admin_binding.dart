// lib/app/bindings/admin_binding.dart
import 'package:coba4/app/modules/Admin/controller/admin_controller.dart';
import 'package:get/get.dart';


class AdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminController>(() => AdminController());
  }
}