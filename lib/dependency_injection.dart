
import 'package:coba4/app/modules/Connection_wifi/binding/connection_binding.dart';


class DependencyInjection {
  
  static void init() {
    ConnectionBinding().dependencies();
  }
}