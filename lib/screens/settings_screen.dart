// screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task/controllers/auth_controller.dart';

class SettingsScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EFEF), // Match cart background for consistency
      body: Obx(() {
        if (authController.firestoreUser.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = authController.firestoreUser.value!;

        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // User Profile Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white, // White background for the card
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context).colorScheme.primary, // Themed color
                    child: const Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Settings Options
            _buildSettingsTile(
              context,
              icon: Icons.manage_accounts,
              title: 'Account Settings',
              onTap: () {
                Get.snackbar('Coming Soon', 'This feature is not yet implemented.', snackPosition: SnackPosition.TOP);
              },
            ),
            _buildSettingsTile(
              context,
              icon: Icons.notifications,
              title: 'Notifications',
              onTap: () {
                Get.snackbar('Coming Soon', 'This feature is not yet implemented.', snackPosition: SnackPosition.TOP);
              },
            ),
            _buildSettingsTile(
              context,
              icon: Icons.lock,
              title: 'Privacy & Security',
              onTap: () {
                Get.snackbar('Coming Soon', 'This feature is not yet implemented.', snackPosition: SnackPosition.TOP);
              },
            ),
            const Divider(height: 40),

            // Logout Button
            _buildSettingsTile(
              context,
              icon: Icons.logout,
              title: 'Logout',
              isLogout: true,
              onTap: () {
                Get.defaultDialog(
                  title: "Logout",
                  middleText: "Are you sure you want to log out?",
                  textConfirm: "Yes, Logout",
                  textCancel: "Cancel",
                  confirmTextColor: Colors.white,
                  buttonColor: Get.theme.colorScheme.primary, // Yellow confirm button
                  cancelTextColor: Colors.black54,
                  onConfirm: () {
                    authController.signOut();
                  },
                );
              },
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSettingsTile(BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          icon,
          color: isLogout ? Colors.red.shade400 : Theme.of(context).colorScheme.primary, // Themed color
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: isLogout ? Colors.red.shade400 : Colors.black87,
            fontWeight: isLogout ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: isLogout ? null : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}