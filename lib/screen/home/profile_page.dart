import 'package:ecommerce/screen/home/mychat.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top Section with Profile Info
          Container(
            decoration: BoxDecoration(
              color: Colors.green, // Background color for the top section
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30), // Bottom left corner rounded
                bottomRight: Radius.circular(30), // Bottom right corner rounded
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Back Button and Edit Profile Button in Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                        // Navigate to home if no route to pop
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to Edit Profile
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text('Edit Profile'),
                    ),
                  ],
                ),
                // Profile Avatar
                CircleAvatar(
                  radius: 50,
                  // backgroundColor: Colors.white,
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ),

                // CircleAvatar(
                //   radius: 50,
                //   backgroundColor: Colors.white,
                //   child: Icon(
                //     Icons.person,
                //     size: 60,
                //     color: Colors.grey,
                //   ),
                // ),

                SizedBox(height: 6),
                // Profile Name
                Text(
                  'XYZ Name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                // Email
                Text(
                  'xyz@123gmail.com',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          // Tiles Section

          Expanded(
            child: ListView(
              children: [
                _buildListTile(
                  context,
                  icon: Icons.local_shipping_outlined,
                  title: 'Upcoming Orders',
                  onTap: () {},
                ),
                _buildListTile(
                  context,
                  icon: Icons.location_on_outlined,
                  title: 'Manage Address',
                  onTap: () {},
                ),
                _buildListTile(
                  context,
                  icon: Icons.payment_outlined,
                  title: 'Update Payment',
                  onTap: () {},
                ),
                _buildListTile(
                  context,
                  icon: Icons.chat_bubble_outline,
                  title: 'My Chats',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserChatScreen(),
                      ),
                    );
                  },
                ),
                _buildListTile(
                  context,
                  icon: Icons.chat_bubble_outline,
                  title: 'Sign Out',
                  onTap: () {
                    _signOut(context);
                  },
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
      await FirebaseAuth.instance.signOut();

      // Clear saved user data from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('uid');

      // Navigate back to login screen
      GoRouter.of(context).go('/signin');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign Out failed: ${e.toString()}')),
      );
    }
  }

  Widget _buildListTile(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: Colors.grey[100],
        leading: Icon(
          icon,
          color: Colors.black,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
      ),
    );
  }
}
