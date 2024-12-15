part of 'app_pages.dart';
// DO NOT EDIT. This is code generated via package:get_cli/get_cli.dart

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const SIGNIN = _Paths.SIGNIN;
  static const LOGIN = _Paths.LOGIN;
  static const GAMEDETAILSCREEN = _Paths.GAMEDETAILSCREEN;
  static const LANDING = _Paths.LANDING;
  static const ABOUT = _Paths.ABOUT;

  //Tambahan Getconnect
  static const GETCONNECT = _Paths.GETCONNECT;
  static const ARTICLE_DETAILS = _Paths.ARTICLE_DETAILS;
  static const ARTICLE_DETAILS_WEBVIEW = _Paths.ARTICLE_DETAILS_WEBVIEW;

  // Rute untuk halaman NoConnection
  static const NO_CONNECTION = _Paths.NO_CONNECTION;  // Tambahkan rute baru ini
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const SIGNIN = '/signin';
  static const LOGIN = '/login';
  static const GAMEDETAILSCREEN = '/GameDetailScreen';
  static const LANDING = '/lending';
  static const ABOUT = '/about';

  //Tambahan Getconnect
  static const GETCONNECT = '/get_connect_view';
  static const ARTICLE_DETAILS = '/article_details';
  static const ARTICLE_DETAILS_WEBVIEW = '/article_details_webview';

  // Path untuk NoConnectionView
  static const NO_CONNECTION = '/no_connection';  // Tambahkan path baru ini
}

class AppRoutes {
  static const DESK = '/desk';
  static const DESKLIST = '/desklist';
  static const PROFILE = '/profile';
  static const SEARCH = '/search';
  static const CREATETASKSCREEN = '/createtaskscreen';
  static const ABOUT = '/about';
}
