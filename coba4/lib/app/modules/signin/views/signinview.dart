import 'package:coba4/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../signin/controllers/signincontroller.dart'; // Pastikan jalur ini benar
import 'package:cloud_firestore/cloud_firestore.dart'; // Jika Anda tidak menggunakan Firestore di sini, Anda bisa menghapusnya
import 'package:firebase_auth/firebase_auth.dart'; // Import ini masih diperlukan

class signinview extends StatelessWidget {
  @override
  State<signinview> createState() =>
      _RegisterPageState(); // Mendapatkan instance AuthController
}

class _RegisterPageState extends State<signinview> {
  final AuthController _authController = Get.put(AuthController());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/backgroundlandingpage.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'GAMENET',
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'SIGN IN',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                TextField(
                  onChanged: (value) => controller.email.value = value,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[800],
                    hintText: 'Email or Phone no',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 15),
                TextField(
                  onChanged: (value) => controller.password.value = value,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[800],
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Validasi input sebelum melakukan sign-in
                    if (controller.email.value.isEmpty ||
                        controller.password.value.isEmpty) {
                      Get.snackbar(
                          'Error', 'Email and Password cannot be empty.',
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white);
                      return;
                    }

                    // Panggil metode sign-in
                    controller.signInWithEmailAndPassword();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Sign In',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Obx(() => Checkbox(
                              value: controller.rememberMe.value,
                              onChanged: (value) =>
                                  controller.toggleRememberMe(),
                              activeColor: Colors.white,
                              checkColor: Colors.black,
                            )),
                        Text('Remember me',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        // Logika "Need Help?" bisa ditambahkan di sini
                      },
                      child: Text('Need Help?',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
