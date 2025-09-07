// screens/product_list_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../controllers/cart_controller.dart';

class ProductListScreen extends StatelessWidget {
  final productController = Get.find<ProductController>();
  final cartController = Get.find<CartController>();

  ProductListScreen({super.key});

  Widget _buildProductImage(String imageUrl) {
    Widget imageWidget;
    if (imageUrl.startsWith('http')) {
      imageWidget = Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 150,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Icon(Icons.broken_image, color: Colors.grey));
        },
      );
    } else {
      imageWidget = Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 150,
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Icon(Icons.image_not_supported, color: Colors.grey));
        },
      );
    }
    return SizedBox(
      height: 150,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: imageWidget,
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        IconData icon = Icons.star_border;
        if (index < rating.floor()) {
          icon = Icons.star;
        } else if (index < rating) {
          icon = Icons.star_half;
        }
        return Icon(icon, color: Colors.amber, size: 14);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: productController.products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.65, // ✅ more vertical space to fix overflow
        ),
        itemBuilder: (context, index) {
          final product = productController.products[index];
          return Card(
            elevation: 3,
            shadowColor: Colors.black26,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductImage(product.imageUrl),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 14, // ✅ slightly smaller to avoid overflow
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            _buildRatingStars(product.rating),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '₹${product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 15, // ✅ adjusted font size
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            SizedBox(
                              width: 36,
                              height: 36,
                              child: ElevatedButton(
                                onPressed: () => cartController.addToCart(product),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                  shape: const CircleBorder(),
                                  padding: EdgeInsets.zero,
                                ),
                                child: const Icon(Icons.add_shopping_cart, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
