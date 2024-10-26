import 'package:coba4/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var rememberMe = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );

      // Sign-in successful, navigate to the home page after sign-in
      // Use userCredential here to get the user ID or other info if needed
      print("User signed in: ${userCredential.user?.uid}"); // Print the user ID

      // Navigate to the intended page after successful sign-in
      Get.offAllNamed(Routes.LOGIN); // Change this to your intended page

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar('Error', 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Get.snackbar('Error', 'Wrong password provided for that user.');
      } else {
        Get.snackbar('Error', e.message ?? 'An unknown error occurred.');
      }
    } catch (e) {
      Get.snackbar('Error', 'An unknown error occurred.');
    }
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }
}
