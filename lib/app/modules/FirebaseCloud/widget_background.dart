import 'package:flutter/material.dart';

class WidgetBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Menambahkan gambar sebagai background
        Image.asset(
          'assets/images/backgroundlandingpage.png', // Ganti dengan path gambar Anda
          fit: BoxFit.cover, // Mengatur gambar agar memenuhi area
          width: double.infinity, // Lebar penuh
          height: double.infinity, // Tinggi penuh
        ),
        // Anda masih bisa menambahkan overlay atau elemen lain di atas gambar
        Positioned(
          top: -64,
          right: -128,
          child: Container(
            width: 256.0,
            height: 256.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9000),
              // Menambahkan efek jika diperlukan

            ),
          ),
        ),
        Positioned(
          top: -164,
          right: -8.0,
          child: Container(
            width: 256.0,
            height: 256.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9000),

            ),
          ),
        ),
      ],
    );
  }
}
