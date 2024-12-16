import 'package:flutter/material.dart';

class NoConnectionView extends StatelessWidget {
  const NoConnectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,  // Memberikan background gelap untuk suasana gamers
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ikon dengan ukuran besar dan warna menarik
            Icon(
              Icons.signal_wifi_off,  // Menggunakan ikon yang sesuai dengan koneksi
              size: 120,
              color: Colors.redAccent,
            ),
            SizedBox(height: 20),
            // Judul dengan gaya font yang lebih keren
            Text(
              'CONNECTION LOST',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 10),
            // Pesan tambahan dengan gaya teks yang lebih menarik
            Text(
              'Oops! It seems like we lost the connection to the server.\nCheck your Wi-Fi or mobile data and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontFamily: 'PressStart2P', // Font pixelated untuk efek retro gamer
              ),
            ),
            SizedBox(height: 40),
            // Tombol untuk mencoba ulang
            ElevatedButton(
              onPressed: () {
                // Aksi untuk mencoba ulang
                print("Trying to reconnect...");
                // Anda bisa menambahkan logika untuk mencoba menghubungkan kembali jika diinginkan
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,  // Tombol berwarna teal yang kontras
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'TRY AGAIN',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
