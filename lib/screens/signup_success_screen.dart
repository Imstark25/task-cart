// screens/signup_success_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:task/screens/dashboard_screen.dart';

class SignUpSuccessScreen extends StatefulWidget {
  const SignUpSuccessScreen({super.key});

  @override
  State<SignUpSuccessScreen> createState() => _SignUpSuccessScreenState();
}

class _SignUpSuccessScreenState extends State<SignUpSuccessScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToDashboard();
  }

  void _navigateToDashboard() {
    // Wait for 4 seconds, then navigate to Dashboard and clear the stack
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) { // Ensure the widget is still in the tree
        Get.offAll(() => const DashboardScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // As requested, set the background color to red
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your Lottie animation
            Lottie.asset(
              'assets/task3.json',
              width: 250,
              height: 250,
            ),
            const SizedBox(height: 20),
            const Text(
              'Account Created!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Redirecting to the shop...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}