// screens/user_check_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task/controllers/auth_controller.dart';
import 'package:task/screens/dashboard_screen.dart';
import 'package:task/screens/login_screen.dart';

class UserCheckScreen extends StatelessWidget {
  // Initialize AuthController
  final AuthController authController = Get.put(AuthController());

  UserCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Listen to the user state
      if (authController.user.value != null) {
        // If user is logged in, go to Dashboard
        return const DashboardScreen();
      } else {
        // If user is not logged in, go to Login
        return LoginScreen();
      }
    });
  }
}