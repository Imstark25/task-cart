// screens/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:task/screens/user_check_screen.dart'; // Import the new user check screen

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF0F8FF), Color(0xFFE6E6FA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/task.json',
                width: 250,
                height: 250,
                fit: BoxFit.fill,
              ),
              const SizedBox(height: 30),
              const Text(
                'Welcome to the app!',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B0082)),
              ),
              const SizedBox(height: 10),
              const Text(
                'Your journey begins here. Let\'s get started!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Color(0xFF6A5ACD)),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the UserCheckScreen to decide the next step
                  Get.offAll(() => UserCheckScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8A2BE2),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}