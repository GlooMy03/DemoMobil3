import 'package:coba4/app/modules/Game_Detail/modules/article_detail/bindings/article_detail_bindings.dart';
import 'package:coba4/app/modules/Game_Detail/modules/article_detail/views/article_detail_view.dart';
import 'package:coba4/app/modules/Game_Detail/modules/article_detail/views/article_detail_web_view.dart';
import 'package:coba4/app/modules/Game_Detail/modules/get_connect/bindings/get_connect_binding.dart';
import 'package:coba4/app/modules/Game_Detail/modules/get_connect/views/get_connect_view.dart';
import 'package:coba4/app/modules/Game_Detail/modules/home/views/desk_view.dart';
import 'package:coba4/app/modules/home/views/home_view.dart';
import 'package:coba4/app/modules/login/views/loginview.dart';
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

    //tambahan Getconnect
        GetPage(
        name: _Paths.GETCONNECT,
        page: () => const GetConnectView(),
        binding: GetConnectBinding()),
    GetPage(
        name: _Paths.ARTICLE_DETAILS,
        page: () => ArticleDetailPage(article: Get.arguments),
        binding: ArticleDetailBinding()),
    GetPage(
        name: _Paths.ARTICLE_DETAILS_WEBVIEW,
        page: () => ArticleDetailWebView(article: Get.arguments),
        binding: ArticleDetailBinding()),
    GetPage(name: AppRoutes.DESK, page: () => DeskView()),
  ];
}

