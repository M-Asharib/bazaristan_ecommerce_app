import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startSplashScreen();
  }

  Future<void> _startSplashScreen() async {
    // Delay for 5 seconds
    await Future.delayed(Duration(seconds: 5));
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');

    if (uid != null) {
      // User is logged in, fetch role and navigate accordingly
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('customers')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        String role = userDoc['role'];

        // Navigate based on role
        if (role == 'admin') {
          Navigator.pushReplacementNamed(context, '/homeadmin');
        } else {
          GoRouter.of(context).go('/home');
        }
      }
    } else {
      // If no user is logged in, navigate to Login screen
      GoRouter.of(context).go('/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Color
          Positioned.fill(
            child: Container(color: Colors.white),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Splash Logo
                Image.asset(
                  'assets/images/logo.png', // Place your logo in assets/images
                  width: 500,
                  height: 300,
                ),
                SizedBox(height: 20),
                // Text(
                //   "Bazaaristan",
                //   style: TextStyle(
                //     fontSize: 24,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.black,
                //   ),
                // ),
                // SizedBox(height: 20),
                // CircularProgressIndicator(), // Loading Indicator
              ],
            ),
          ),
        ],
      ),
    );
  }
}
