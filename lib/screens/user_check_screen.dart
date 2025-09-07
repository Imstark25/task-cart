// screens/user_check_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task/controllers/auth_controller.dart';
import 'package:task/screens/dashboard_screen.dart';
import 'package:task/screens/login_screen.dart';
import 'package:task/screens/signup_screen.dart'; // Import signup screen

class UserCheckScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  UserCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (authController.user.value != null) {
        // User is logged in, go to dashboard
        return const DashboardScreen();
      } else {
        // User is not logged in, show SignUpScreen as the default
        return SignUpScreen();
      }
    });
  }
}