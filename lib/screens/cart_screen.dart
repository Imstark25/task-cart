// screens/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../ model/cart_item_model.dart';
import '../ model/product_model.dart';
import '../controllers/cart_controller.dart';

class CartScreen extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();
  final VoidCallback onContinueShopping;

  CartScreen({super.key, required this.onContinueShopping});

  // Helper widget to conditionally build the cart image
  Widget _buildCartImage(String imageUrl) {
    Widget imageWidget;
    // Set fixed size as per spec (60-70dp)
    const double imageSize = 70.0;

    if (imageUrl.startsWith('http')) {
      imageWidget = Image.network(
        imageUrl,
        width: imageSize,
        height: imageSize,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: imageSize,
          height: imageSize,
          color: Colors.grey[200],
          child: const Icon(Icons.broken_image, color: Colors.grey),
        ),
      );
    } else {
      imageWidget = Image.asset(
        imageUrl,
        width: imageSize,
        height: imageSize,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: imageSize,
          height: imageSize,
          color: Colors.grey[200],
          child: const Icon(Icons.image_not_supported, color: Colors.grey),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: imageWidget,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EFEF), // Overall background color
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0EFEF), // Match overall background
        elevation: 0,
        title: const Text(
          'My Bag',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Get.back(), // Navigates back to previous screen
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Obx(
            () {
          if (cartController.cartItems.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Your bag is empty.', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Text('Start adding some great products!', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cartController.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartController.cartItems[index];
                    return _buildCartItemDismissible(context, item);
                  },
                ),
              ),
              _buildBottomSummaryAndButtons(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartItemDismissible(BuildContext context, CartItem item) {
    return Dismissible(
      key: Key(item.productId),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        // Trash icon with 24dp size as per spec
        child: const Icon(Icons.delete, color: Colors.white, size: 24),
      ),
      confirmDismiss: (direction) async {
        return await Get.defaultDialog<bool>(
          title: "Remove Item",
          middleText: "Are you sure you want to remove ${item.name} from your bag?",
          textConfirm: "Yes",
          textCancel: "No",
          confirmTextColor: Colors.white,
          buttonColor: Theme.of(context).colorScheme.primary,
          onConfirm: () => Get.back(result: true),
          onCancel: () => Get.back(result: false),
        );
      },
      onDismissed: (direction) {
        cartController.removeItemCompletely(item);
      },
      child: _buildCartItemCard(context, item),
    );
  }

  Widget _buildCartItemCard(BuildContext context, CartItem item) {
    final dummyProduct = Product(
      id: item.productId, name: item.name, price: item.price,
      imageUrl: item.imageUrl, rating: 0,
    );

    // Each row card is wrapped in a container that will be ~90-120dp high based on content
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Thumbnail (70dp)
          _buildCartImage(item.imageUrl),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. Product Name (16sp, 2 lines)
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // 3. Price (Bold, 16sp)
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16, // Fits 16-18sp spec
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Color: Cherry', // Static text
                  style: TextStyle(
                    fontSize: 12, // Small label spec
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // 4. Quantity Stepper
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => cartController.decrementFromCart(item),
                  child: const Icon(Icons.remove, size: 18, color: Colors.black54),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '${item.quantity}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => cartController.addToCart(dummyProduct),
                  child: const Icon(Icons.add, size: 18, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 5. Checkout Bar (Fixed bottom section)
  Widget _buildBottomSummaryAndButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Total price section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              Obx(
                    () => Text(
                  '\$${cartController.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Checkout Button (meets 50-56dp height spec)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.snackbar(
                  'Checkout', 'This feature is not yet implemented.',
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Get.theme.colorScheme.primary,
                  colorText: Get.theme.colorScheme.onPrimary,
                  margin: const EdgeInsets.all(12),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 18), // This creates a ~56dp height
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                shadowColor: Colors.black.withOpacity(0.2),
              ),
              child: const Text(
                'Check out',
                style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: onContinueShopping,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                'Continue shopping',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}