import 'package:coba4/app/modules/home/views/home_view.dart';
import 'package:coba4/app/modules/login/views/loginview.dart';
import 'package:coba4/app/modules/profil_edit/bindings/profile_binding.dart';
import 'package:coba4/app/modules/profil_edit/views/profile_view.dart';
import 'package:coba4/app/modules/signin/views/signinview.dart';
import 'package:get/get.dart';

import '../modules/landing_page/bindings/landing_binding.dart';
import '../modules/landing_page/views/landing_page.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LANDING;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
    ),
    GetPage(
      name: _Paths.SIGNIN,
      page: () => RegisterPage(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginPage(),
    ),
    GetPage(
      name: _Paths.LANDING,
      page: () => LandingPage(),
      binding: LandingBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfilePage(),
      binding: ProfileBinding(),
    ),
  ];
}
