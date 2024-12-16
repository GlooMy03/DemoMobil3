import 'package:coba4/app/modules/detail_game/controller/game_detail_controller.dart';
import 'package:get/get.dart';


class GameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GameDetailController>(() => GameDetailController());
  }
}
