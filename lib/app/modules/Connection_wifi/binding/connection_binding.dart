import 'package:coba4/app/modules/Connection_wifi/controller/connection_controller.dart';
import 'package:get/get.dart';


class ConnectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ConnectionController>(ConnectionController(), permanent: true);
  } 
}