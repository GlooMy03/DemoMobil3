import 'package:coba4/app/modules/Search/Controllers/game_search_controller.dart';
import 'package:get/get.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GameSearchController>( // Ganti SearchController dengan GameSearchController
      () => GameSearchController(),
    );
  }
}