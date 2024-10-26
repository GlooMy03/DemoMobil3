import 'package:coba4/app/modules/homepage/screens/game_detail_screen.dart';
//import 'package:coba4/app/modules/homepage/screens/home_screen.dart';
import 'package:coba4/app/modules/login/bindings/loginbinding.dart';
import 'package:coba4/app/modules/login/views/loginview.dart';
import 'package:coba4/app/modules/signin/bindings/signinbinding.dart';
import 'package:coba4/app/modules/signin/views/signinview.dart';
import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SIGNIN,
      page: () => signinview(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => loginview(),
      binding: loginbinding(),
    ),
    GetPage(
      name: _Paths.GAMEDETAILSCREEN,
      page: () => const GameDetailScreen(),
    ),
  ];
}
