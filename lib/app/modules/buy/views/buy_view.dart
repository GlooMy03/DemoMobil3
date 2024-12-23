import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../buy/controllers/buy_controller.dart';

class BuyView extends GetView<BuyController> {
  const BuyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E21),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Payment Info',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Game Item Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1D1E33),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/ghost.jpeg',
                      width: 60,
                      height: 60,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ghost',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Game Ghost',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Rp ${controller.totalAmount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Subtotal and Total
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Subtotal :',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Rp ${controller.totalAmount}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.grey),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total :',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Rp ${controller.totalAmount}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // GameNet Point Notice
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.red,
              child: const Text(
                'Kamu mendapatkan GameNet Point',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 24),

            // Payment Method Details
            // Replace the Payment Method and GameNet Account sections with:

// Payment Method Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Payment Method',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const Text(
                  'GameNet Wallet',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),

            const SizedBox(height: 16),

// GameNet Account Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'GameNet Account',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Obx(() => Text(
                      controller.accountId.value,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    )),
              ],
            ),

            const Spacer(),

            // Agreement Checkbox
            Row(
              children: [
                Obx(() => Checkbox(
                      value: controller.isAgreed.value,
                      onChanged: (_) => controller.toggleAgreement(),
                      fillColor: MaterialStateProperty.all(Colors.red),
                    )),
                const Expanded(
                  child: Text(
                    'Saya setuju dengan ketentuan dan perjanjian pelanggan GameNet',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),

            // Buy Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.processPurchase,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Buy',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
