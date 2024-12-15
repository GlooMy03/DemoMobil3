
import 'package:coba4/app/modules/connection/bindings/connection_binding.dart';

class DependencyInjection {
  
  static void init() {
    ConnectionBinding().dependencies();
  }
}