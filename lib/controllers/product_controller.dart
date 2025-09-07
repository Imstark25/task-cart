import 'package:get/get.dart';
import '../ model/product_model.dart';


class ProductController extends GetxController {
  final products = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchStaticProducts();
  }

  void fetchStaticProducts() {
    products.value = [
      Product(
        id: '1',
        name: 'Classic Leather Jacket',
        price: 149.99,
        imageUrl: 'assets/belt.jpg',
        rating: 4.5,
      ),
      Product(
        id: '2',
        name: 'Wireless Bluetooth Headphones',
        price: 89.50,
        imageUrl: 'assets/headphones.jpeg',
        rating: 3,
      ),
      Product(
        id: '3',
        name: 'Modern Smartwatch',
        price: 220.00,
        imageUrl: 'assets/watch.jpg',
        rating: 4.2,
      ),
      Product(
        id: '4',
        name: 'Running Shoes (Unisex)',
        price: 75.25,
        imageUrl: 'https://picsum.photos/seed/shoes/400/300',
        rating: 4.0,
      ),
      Product(
        id: '5',
        name: 'Professional DSLR Camera',
        price: 699.99,
        imageUrl: 'https://picsum.photos/seed/camera/400/300',
        rating: 4.9,
      ),
      Product(
        id: '6',
        name: 'Organic Green Tea (50 bags)',
        price: 15.99,
        imageUrl: 'https://picsum.photos/seed/tea/400/300',
        rating: 4.7,
      ),
    ];
  }
}
