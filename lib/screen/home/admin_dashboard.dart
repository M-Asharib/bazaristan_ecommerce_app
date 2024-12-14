import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[300],
                  child: Icon(
                    Icons.admin_panel_settings,
                    size: 50,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Admin Dashboard',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'admin@ecommerce.com', // You can dynamically get this email
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildListTile(
                  context,
                  icon: Icons.store_outlined,
                  title: 'categories',
                  onTap: () {
                    // Navigate to manage products page
                    Navigator.pushReplacementNamed(context, '/cate');
                  },
                ),
                _buildListTile(
                  context,
                  icon: Icons.shopping_cart_outlined,
                  title: 'products',
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/products');
                    
                  },
                ),
                _buildListTile(
                  context,
                  icon: Icons.supervised_user_circle_outlined,
                  title: 'Manage Users',
                  onTap: () {
                    // Navigate to user management page
                  },
                ),
                _buildListTile(
                  context,
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () {
                    // Navigate to settings page
                  },
                ),
                _buildListTile(
                  context,
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  onTap: () {
                    // Navigate to notifications page
                  },
                ),
                _buildListTile(
                  context,
                  icon: Icons.info_outline,
                  title: 'About',
                  onTap: () {
                    // Navigate to About page
                  },
                ),
                _buildListTile(
                  context,
                  icon: Icons.logout,
                  title: 'Sign Out',
                  onTap: () async {
                    // Handle logout
                    await _signOut(context);
                  },
                  isSignOut: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Method to handle logout
  Future<void> _signOut(BuildContext context) async {
    try {
      // Sign out from Firebase
      // Assuming FirebaseAuth is imported and initialized
      // await FirebaseAuth.instance.signOut();

      // Clear saved user data from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('uid');

      // Navigate back to login screen
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign Out failed: ${e.toString()}')),
      );
    }
  }

  Widget _buildListTile(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap,
      bool isSignOut = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        tileColor: Colors.grey[200],
        leading: Icon(
          icon,
          color: isSignOut ? Colors.red : Colors.black,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: isSignOut ? Colors.red : Colors.black,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[600],
        ),
      ),
    );
  }
}
