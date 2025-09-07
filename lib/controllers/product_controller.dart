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
        name: 'Classic Leather belt',
        price: 149.99,
        imageUrl: 'assets/belt.jpg',
        rating: 4.5,
      ),
      Product(
        id: '2',
        name: 'Wireless Headphones',
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
        name: 'Running Shoes',
        price: 75.25,
        imageUrl: 'assets/shoe.jpg',
        rating: 4.0,
      ),
      Product(
        id: '5',
        name: 'DSLR Camera',
        price: 699.99,
        imageUrl: 'assets/camera.jpg',
        rating: 4.9,
      ),
      Product(
        id: '6',
        name: 'classic handbag',
        price: 15.99,
        imageUrl: 'assets/handbag.jpg',
        rating: 4.7,
      ),
    ];
  }
}
