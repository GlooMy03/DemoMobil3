import 'package:coba4/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeskView extends StatelessWidget {
  const DeskView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0E1234), // Background color sesuai gambar
      appBar: AppBar(
        backgroundColor: Color(0xFF0E1234),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.lock_outline, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: 350,
          decoration: BoxDecoration(
            color: Color(0xFF162349), // Warna latar container
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Game image
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Image.asset(
                  'assets/images/eldenring.jpeg',
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),

              // Game title
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'ELDEN RING',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Game description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Elden Ring takes place in the Lands Between, a realm blessed by entities called outer gods. Most prominent is the Greater Will, who created the Elden Ring, a collection of runes that govern physics. The Greater Will\'s emissary, the Two Fingers, made a woman named Marika the Elden Ring\'s vessel, ascending her to godhood.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Spacing below the description
              SizedBox(height: 30),

              // Buy button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Add your buy button logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF4B4B),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'BUY',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Spacing below the button
              SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/desklist');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF4B4B),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Community',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
