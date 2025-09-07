import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:task/screens/onboarding_screen.dart'; // Import the onboarding screen
import 'firebase_options.dart';
import 'controllers/auth_controller.dart'; // Import AuthController

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(AuthController()); // Register the AuthController
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'e-commerce',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Use the amber color from the design for primary elements
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFFC107)),
        useMaterial3: true,
        // Optional: Customize text themes or app bar themes globally here
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black, // For title and icons
          elevation: 0, // Flat app bar
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F8F8), // Light background color
      ),
      home: const OnboardingScreen(), // The app still starts with onboarding
    );
  }
}