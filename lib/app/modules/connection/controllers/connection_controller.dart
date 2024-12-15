import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../login/views/loginview.dart';
import '../views/no_connection_view.dart';

class ConnectionController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  final GetStorage _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen((connectivityResults) {
      // Jika connectivityResults adalah List<ConnectivityResult>, kita ambil hasil pertama
      _updateConnectionStatus(connectivityResults.first);
    });
  }

  // Fungsi untuk mengupdate status koneksi
  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    // kondisi dimana aplikasi mendeteksi bawha tidak ada koneksi sama sekali
    if (connectivityResult == ConnectivityResult.none) {
      _storage.write('last_route', Get.currentRoute);
      Get.offAll(() => const NoConnectionView());
    } else {
      String? lastRoute = _storage.read('last_route');
      if (lastRoute != null) {
        // Navigasi ke halaman terakhir yang dilihat
        Get.offAllNamed(lastRoute);
        _storage.remove(
            'last_route'); // Hapus setelah mengarahkan ke halaman terakhir
      } else {
        if (Get.currentRoute == '/NoConnectionView') {
          Get.offAll(() => LoginPage());
        }
      }
    }
  }
}
