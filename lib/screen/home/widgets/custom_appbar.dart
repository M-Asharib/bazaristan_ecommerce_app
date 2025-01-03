import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String role;

  const CustomAppBar({required this.role, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          // Handle menu action
        },
      ),
      title: Text(
        role == 'admin' ? 'Admin Dashboard' : 'Ecommerce App',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_none),
          onPressed: () {
            // Handle notifications action
          },
        ),
        IconButton(
          icon: Icon(Icons.shopping_cart_outlined),
          onPressed: () {
            // Handle cart action
          },
        ),
      ],
      centerTitle: true, // Centers the title in the app bar
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 1, // Adds a subtle shadow
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
