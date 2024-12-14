import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isAdmin; // Flag to differentiate between Admin and Customer

  BottomNavigation({
    required this.currentIndex,
    required this.onTap,
    this.isAdmin = false, // Default is false for customer
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.green, // Set background color to green
      selectedItemColor: Colors.white, // Active icon and label color (white)
      unselectedItemColor: Colors.white
          .withOpacity(0.6), // Inactive items (slightly transparent white)
      items: isAdmin
          ? _adminNavigationItems() // Admin navigation
          : _customerNavigationItems(), // Customer navigation
    );
  }

  // Navigation items for Admin
  List<BottomNavigationBarItem> _adminNavigationItems() {
    return [
      BottomNavigationBarItem(
        icon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.shopping_bag_outlined),
        label: 'Manage Products',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.list_alt),
        label: 'View Orders',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.supervised_user_circle_outlined),
        label: 'Manage Users',
      ),
    ];
  }

  // Navigation items for Customer
  List<BottomNavigationBarItem> _customerNavigationItems() {
    return [
      BottomNavigationBarItem(
        icon: Icon(Icons.shopping_cart),
        label: 'Cart',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];
  }
}
