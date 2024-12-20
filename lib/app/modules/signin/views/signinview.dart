import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // Tambahkan connectivity_plus
import '../../signin/controllers/signincontroller.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthController _authController = Get.put(AuthController());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Connectivity _connectivity = Connectivity(); // Instance untuk memeriksa koneksi

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fungsi untuk memeriksa koneksi internet
  Future<bool> _checkConnection() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // Arahkan ke halaman NoConnection jika tidak ada koneksi
      Get.toNamed('/NoConnectionView');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Color(0xFF0B0D2A), // Warna latar belakang utama
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/part.png', // Ganti dengan path background yang benar
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height * 0.4,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/fight.png', // Ganti dengan path karakter petarung
              fit: BoxFit.contain,
              height: MediaQuery.of(context).size.height * 0.35,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(flex: 2),
                Text(
                  'SIGN UP',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'GameNET',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFF69E4D1),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                Spacer(),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade800.withOpacity(0.7),
                    hintText: 'Email or Phone no',
                    hintStyle: TextStyle(color: Colors.grey.shade300),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade800.withOpacity(0.7),
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.grey.shade300),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                ),
                SizedBox(height: 32),
                Obx(() {
                  return ElevatedButton(
                    onPressed: _authController.isLoading.value
                        ? null
                        : () async {
                            // Periksa koneksi internet sebelum registrasi
                            if (await _checkConnection()) {
                              _authController.registerUser(
                                _emailController.text,
                                _passwordController.text,
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF69E4D1),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _authController.isLoading.value
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            'SIGN UP',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  );
                }),
                Spacer(flex: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
