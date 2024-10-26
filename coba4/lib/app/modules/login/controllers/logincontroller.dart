import 'package:get/get.dart';

class logincontroller extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var rememberMe = false.obs;

  void signIn() {
    // Add your sign-in logic here
    if (email.isNotEmpty && password.isNotEmpty) {
      // For now, just printing a message
      print("Log In with Email: ${email.value} and Password: ${password.value}");
    } else {
      print("Please enter email and password.");
    }
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }
}
