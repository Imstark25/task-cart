// controllers/auth_controller.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Import the new user model
import 'package:task/screens/user_check_screen.dart';

import '../ model/user_model.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable for Firebase Auth user state
  final Rxn<User> _firebaseUser = Rxn<User>();
  Rx<User?> get user => _firebaseUser;

  // Observable for Firestore user data
  final Rxn<UserModel> firestoreUser = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    // Bind the auth state from Firebase to our local user object
    _firebaseUser.bindStream(_auth.authStateChanges());

    // Reaction to firebaseUser changes
    ever(_firebaseUser, _setInitialScreen);
  }

  // This function runs whenever the firebaseUser changes
  _setInitialScreen(User? user) {
    if (user != null) {
      // If user is logged in, fetch their data from Firestore
      firestoreUser.bindStream(streamFirestoreUser());
    } else {
      // If user logs out, clear their firestore data
      firestoreUser.value = null;
    }
  }

  // Stream to listen for user document changes in Firestore
  Stream<UserModel> streamFirestoreUser() {
    if (_firebaseUser.value != null) {
      return _firestore
          .collection('users')
          .doc(_firebaseUser.value!.uid)
          .snapshots()
          .map((snapshot) => UserModel.fromFirestore(snapshot));
    }
    return const Stream.empty(); // Return an empty stream if no user
  }

  void _showAuthError() {
    Get.snackbar(
      'Login Required',
      'You must be logged in to perform this action.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
      margin: const EdgeInsets.all(12),
    );
  }

  // Sign Up with Email and Password
  Future<void> signUp(String name, String email, String phoneNumber, String password) async {
    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Save additional user info to Firestore
      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': name,
          'email': email,
          'phoneNumber': phoneNumber,
        });
      }

      Get.back(); // Close loading dialog. Auth state change will handle navigation.

    } on FirebaseAuthException catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar('Sign Up Failed', e.message ?? 'An unknown error occurred.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError);
    }
  }

  // Login with Email and Password
  Future<void> login(String email, String password) async {
    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      Get.back(); // Close dialog. UserCheckScreen's Obx will handle navigation.
    } on FirebaseAuthException catch (e) {
      Get.back();
      Get.snackbar('Login Failed', e.message ?? 'An unknown error occurred.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError);
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
    Get.offAll(() => UserCheckScreen());
  }
}