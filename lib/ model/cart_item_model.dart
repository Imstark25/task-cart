// model/cart_item_model.dart
class CartItem {
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl; // ADDED THIS LINE

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl, // ADDED THIS LINE
  });

  factory CartItem.fromMap(Map<String, dynamic> data) {
    return CartItem(
      productId: data['productId'] as String,
      name: data['name'] as String,
      price: (data['price'] as num).toDouble(),
      quantity: data['quantity'] as int,
      imageUrl: data['imageUrl'] ?? '', // ADDED THIS LINE (with fallback)
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl, // ADDED THIS LINE
    };
  }
}