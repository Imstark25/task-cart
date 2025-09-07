// controllers/cart_controller.dart
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'; // Needed for Snackbar
import '../ model/cart_item_model.dart';
import '../ model/product_model.dart';


class CartController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final cartItems = <CartItem>[].obs;
  // Get the current user nullable - note: this should ideally be handled via AuthController
  // For now, keeping it here as it was, but a full app would use authController.user.value
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void onInit() {
    super.onInit();
    if (user != null) {
      cartItems.bindStream(fetchUserCartStream());
    } else {
      print('No user logged in. Cart will not be synced.');
    }
  }

  // Separate function to get the cart stream
  Stream<List<CartItem>> fetchUserCartStream() {
    // Re-check user because this might be called later
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('cart')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => CartItem.fromMap(doc.data())).toList();
      });
    }
    return const Stream.empty(); // Return an empty stream if no user
  }

  double get total =>
      cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);

  void _showAuthError() {
    Get.snackbar(
      'Login Required',
      'You must be logged in to use the cart.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.error, // Use theme color
      colorText: Get.theme.colorScheme.onError, // Use theme color
      margin: const EdgeInsets.all(12),
    );
  }

  void addToCart(Product product) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      _showAuthError();
      return;
    }

    final cartDocRef = _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('cart')
        .doc(product.id);

    final existingDoc = await cartDocRef.get();

    if (existingDoc.exists) {
      await cartDocRef.update({'quantity': FieldValue.increment(1)});
    } else {
      await cartDocRef.set(CartItem(
        productId: product.id,
        name: product.name,
        price: product.price,
        quantity: 1,
        imageUrl: product.imageUrl,
      ).toMap());
    }
    Get.snackbar(
      'Added to Cart',
      '${product.name} added to your bag!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.theme.colorScheme.primary, // Use theme color
      colorText: Get.theme.colorScheme.onPrimary, // Use theme color
      margin: const EdgeInsets.all(12),
    );
  }

  Future<void> decrementFromCart(CartItem item) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      _showAuthError();
      return;
    }

    final cartDocRef = _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('cart')
        .doc(item.productId);

    if (item.quantity > 1) {
      await cartDocRef.update({'quantity': FieldValue.increment(-1)});
    } else {
      await cartDocRef.delete();
      Get.snackbar('Removed', '${item.name} removed from bag!');
    }
  }

  // This method is for completely removing an item (e.g., via a "swipe-to-delete")
  Future<void> removeItemCompletely(CartItem item) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      _showAuthError();
      return;
    }
    await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('cart')
        .doc(item.productId)
        .delete();

    Get.snackbar(
      'Removed',
      '${item.name} removed from your bag!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.shade400,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
    );
  }
}