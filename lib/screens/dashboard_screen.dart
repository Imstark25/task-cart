// screens/dashboard_screen.dart
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

  // Find/Put controllers
  final AuthController authController = Get.find<AuthController>();
  final ProductController productController = Get.put(ProductController());
  final CartController cartController = Get.put(CartController());

  // Widget list is now an instance variable, not static
  late final List<Widget> _widgetOptions;

  static const List<Text> _appBarTitles = [
    Text('Products'),
    Text('My Bag'),
    Text('Settings'),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize the list here to pass the callback function
    _widgetOptions = <Widget>[
      ProductListScreen(),
      // Pass the function to switch to tab 0 directly to the CartScreen
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
        automaticallyImplyLeading: false, // Remove back button from AppBar
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            activeIcon: Icon(Icons.shopping_bag),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Bag',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}