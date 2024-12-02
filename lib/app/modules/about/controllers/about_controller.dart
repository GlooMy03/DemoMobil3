import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutController extends GetxController {
  final String companyName = "GameNet";
  final String officeLocation = "Malang Town Square";
  final String officeCoordinates =
      "-7.956893854896705, 112.61875882066485"; // Latitude, Longitude
  final String phoneNumber = "+62 896-0684-5251";

  Future<void> openGoogleMaps() async {
    final googleMapsUrl =
        "https://www.google.com/maps/dir/?api=1&destination=$officeCoordinates";
    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl),
          mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Error',
        'Tidak dapat membuka Google Maps.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Fungsi untuk memanggil nomor telepon kantor
  Future<void> callPhoneNumber() async {
    final telUrl = "tel:$phoneNumber";
    if (await canLaunchUrl(Uri.parse(telUrl))) {
      await launchUrl(Uri.parse(telUrl), mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Error',
        'Tidak dapat melakukan panggilan.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
