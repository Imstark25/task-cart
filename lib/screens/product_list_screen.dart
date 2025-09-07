import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../controllers/cart_controller.dart';

class ProductListScreen extends StatelessWidget {
  final productController = Get.find<ProductController>();
  final cartController = Get.find<CartController>();

  ProductListScreen({super.key});

  // Product Image
  Widget _buildProductImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 120, // smaller fixed height
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Icon(Icons.broken_image, color: Colors.grey));
        },
      );
    } else {
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 120,
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Icon(Icons.image_not_supported, color: Colors.grey));
        },
      );
    }
  }

  // Rating Stars
  Widget _buildRatingStars(double rating) {
    return Row(
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
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: const Text("Products"), centerTitle: true),
      body: Obx(
            () => GridView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: productController.products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: (screenHeight > 700) ? 0.72 : 0.68, // responsive
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
                  Expanded( // prevents overflow
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 4),
                          _buildRatingStars(product.rating),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              SizedBox(
                                width: 32,
                                height: 32,
                                child: ElevatedButton(
                                  onPressed: () => cartController.addToCart(product),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                    shape: const CircleBorder(),
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: const Icon(Icons.add, size: 16),
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
      ),
    );
  }
}
