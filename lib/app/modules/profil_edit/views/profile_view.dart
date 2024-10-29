import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: controller.updateProfile,
            child: const Text(
              'Save',
              style: TextStyle(
                color: Color(0xFF64FFDA),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Stack(
                  children: [
                    Obx(() {
                      final imagePath = controller.selectedImagePath.value;
                      return CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[800],
                        child: ClipOval(
                          child: imagePath.isEmpty
                              ? const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.white54,
                                )
                              : imagePath.startsWith('http')
                                  ? CachedNetworkImage(
                                      imageUrl: imagePath,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      ),
                                    )
                                  : Image.file(
                                      File(imagePath),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                        ),
                      );
                    }),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: controller.showImagePickerBottomSheet,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFF64FFDA),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  label: 'Name',
                  controller: controller.nameController,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Nomor Hp',
                  controller: controller.phoneController,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Email',
                  controller: controller.emailController,
                ),
              ],
            ),
          ),
          // Loading overlay
          Obx(
            () => controller.isLoading.value
                ? Container(
                    color: Colors.black54,
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF64FFDA)),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[900],
            hintText: label,
            hintStyle: TextStyle(color: Colors.grey[600]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
