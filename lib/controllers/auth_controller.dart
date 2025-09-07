// controllers/auth_controller.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:task/screens/dashboard_screen.dart';
import 'package:task/screens/signup_success_screen.dart';
import 'package:task/screens/signup_screen.dart';

import '../ model/user_model.dart'; // 👈 Add signup screen import



class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Rxn<User> _firebaseUser = Rxn<User>();
  Rx<User?> get user => _firebaseUser;

  final Rxn<UserModel> firestoreUser = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    _firebaseUser.bindStream(_auth.authStateChanges());
    ever(_firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user != null) {
      firestoreUser.bindStream(streamFirestoreUser());
    } else {
      firestoreUser.value = null;
    }
  }

  Stream<UserModel> streamFirestoreUser() {
    if (_firebaseUser.value != null) {
      return _firestore
          .collection('users')
          .doc(_firebaseUser.value!.uid)
          .snapshots()
          .map((snapshot) => UserModel.fromFirestore(snapshot));
    }
    return const Stream.empty();
  }

  /// SIGN UP
  Future<void> signUp(
      String name, String email, String phoneNumber, String password) async {
    try {
      Get.dialog(const Center(child: CircularProgressIndicator()),
          barrierDismissible: false);

      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': name,
          'email': email,
          'phoneNumber': phoneNumber,
        });
      }

      Get.back(); // Close loading dialog
      Get.offAll(() => const SignUpSuccessScreen());
    } on FirebaseAuthException catch (e) {
      Get.back();
      Get.snackbar(
        'Sign Up Failed',
        e.message ?? 'An unknown error occurred.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  /// LOGIN
  Future<void> login(String email, String password) async {
    try {
      Get.dialog(const Center(child: CircularProgressIndicator()),
          barrierDismissible: false);

      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      Get.back();
      Get.offAll(() => const DashboardScreen());
    } on FirebaseAuthException catch (e) {
      Get.back();
      Get.snackbar(
        'Login Failed',
        e.message ?? 'An unknown error occurred.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  /// SIGN OUT
  Future<void> signOut() async {
    await _auth.signOut();
    // 👇 Go directly to signup page
    Get.offAll(() => SignUpScreen());
  }
}
