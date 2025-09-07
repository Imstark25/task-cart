// screens/logout_success_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:task/screens/user_check_screen.dart'; // We navigate back to the root check screen

class LogoutSuccessScreen extends StatefulWidget {
  const LogoutSuccessScreen({super.key});

  @override
  State<LogoutSuccessScreen> createState() => _LogoutSuccessScreenState();
}

class _LogoutSuccessScreenState extends State<LogoutSuccessScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  void _navigateToLogin() {
    // Wait for 3 seconds, then navigate to UserCheckScreen (which will show Login)
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Get.offAll(() => UserCheckScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use the standard app background color
      backgroundColor: const Color(0xFFF8F8F8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your new Lottie animation
            Lottie.asset(
              'assets/task4.json',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            const Text(
              'Successfully Logout',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'See you next time!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}