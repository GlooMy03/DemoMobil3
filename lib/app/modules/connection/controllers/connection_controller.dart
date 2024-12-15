import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../views/no_connection_view.dart';

class ConnectionController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  final GetStorage _storage = GetStorage(); // Deklarasi _storage
  final RxBool isConnected = false.obs; // Status koneksi

  @override
  void onInit() async {
    super.onInit();
    await Firebase.initializeApp(); // Inisialisasi Firebase

    // Memantau perubahan status koneksi
    _connectivity.onConnectivityChanged.listen((connectivityResults) {
      // Jika connectivityResults adalah List<ConnectivityResult>, kita ambil hasil pertama
      _updateConnectionStatus(connectivityResults.first);
    });
  }

  // Fungsi untuk mengupdate status koneksi
  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    isConnected(connectivityResult != ConnectivityResult.none);

    if (isConnected.value) {
      Get.snackbar("Connected", "You are now connected to the internet.");
      _uploadPendingData(); // Coba upload data yang tertunda

      // Setelah koneksi berhasil, periksa dan kembali ke halaman terakhir yang disimpan
      String? lastRoute =
          _storage.read('last_route'); // Mengakses _storage dengan benar
      if (lastRoute != null && lastRoute != '/NoConnectionView') {
        Get.offAllNamed(lastRoute); // Navigasi ke rute terakhir yang disimpan
      }
    } else {
      Get.snackbar("Disconnected", "You are disconnected from the internet.");
      // Simpan rute terakhir jika aplikasi terputus
      _storage.write('last_route', Get.currentRoute); // Menyimpan rute terakhir
      if (Get.currentRoute != '/NoConnectionView') {
        Get.offAll(() => const NoConnectionView());
      }
    }
  }

  // Fungsi untuk menyimpan data yang gagal di-upload secara lokal
  void saveDataLocally(Map<String, dynamic> data) {
    List<Map<String, dynamic>> pendingData =
        _storage.read('pending_uploads') ?? [];
    pendingData.add(data);
    _storage.write('pending_uploads', pendingData);
  }

  // Fungsi untuk meng-upload data ke Firestore
  Future<void> uploadDataToFirestore(Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance.collection('data').add(data);
      print("Data successfully uploaded");
    } catch (e) {
      print("Failed to upload data: $e");
      saveDataLocally(data); // Simpan data secara lokal jika gagal
    }
  }

  // Fungsi untuk melanjutkan upload data yang tertunda
  void _uploadPendingData() {
    List<Map<String, dynamic>> pendingData =
        _storage.read('pending_uploads') ?? [];

    if (pendingData.isNotEmpty) {
      Future.delayed(Duration(seconds: 2), () {
        // Menunggu 2 detik untuk memastikan koneksi siap
        for (var data in List.from(pendingData)) {
          uploadDataToFirestore(data).then((_) {
            // Setelah berhasil di-upload, hapus data dari penyimpanan lokal
            pendingData.remove(data);
            _storage.write('pending_uploads', pendingData);
          }).catchError((e) {
            print("Failed to upload data: $e");
          });
        }
      });
    }
  }

  // Fungsi untuk meng-upload data baru
  void uploadNewData(Map<String, dynamic> data) {
    uploadDataToFirestore(data);
  }
}
