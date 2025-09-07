import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task/screens/product_list_screen.dart';
import 'package:task/screens/cart_screen.dart';
import 'package:task/screens/settings_screen.dart';
import '../controllers/product_controller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/auth_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final AuthController authController = Get.find<AuthController>();
  final ProductController productController = Get.put(ProductController());
  final CartController cartController = Get.put(CartController());

  late final List<Widget> _widgetOptions;

  static const List<Text> _appBarTitles = [
    Text('Products'),
    Text('My Cart'),
    Text('Settings'),
  ];

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      ProductListScreen(),
      CartScreen(onContinueShopping: () => _onItemTapped(0)),
      SettingsScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitles.elementAt(_selectedIndex),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: const Color(0xFFF5F5F4),
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // ✅ prevents shifting
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            activeIcon: Icon(Icons.shopping_bag),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF6366F1), // Indigo accent
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        elevation: 12,
        showUnselectedLabels: true,
      ),
    );
  }
}
