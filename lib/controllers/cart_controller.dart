// controllers/cart_controller.dart
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../ model/cart_item_model.dart';
import '../ model/product_model.dart';

class CartController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final cartItems = <CartItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        cartItems.bindStream(fetchUserCartStream(user.uid));
      } else {
        cartItems.clear();
      }
    });
  }

  Stream<List<CartItem>> fetchUserCartStream(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('cart')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => CartItem.fromMap(doc.data())).toList();
    });
  }

  double get total =>
      cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);

  void _showAuthError() {
    Get.snackbar(
      'Login Required',
      'You must be logged in to use the cart.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
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
      backgroundColor: Get.theme.colorScheme.primary,
      colorText: Get.theme.colorScheme.onPrimary,
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
    }
  }

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