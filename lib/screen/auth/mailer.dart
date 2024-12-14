import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class YourScreen extends StatefulWidget {
  @override
  _YourScreenState createState() => _YourScreenState();
}

class _YourScreenState extends State<YourScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? verificationId;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Register user with Email and Password
  Future<void> registerWithEmail() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      print("User registered: ${userCredential.user?.email}");

      // Send verification email
      await userCredential.user?.sendEmailVerification();
      print("Verification email sent to ${_emailController.text}");

      // Prompt the user to check their email
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Email Verification"),
          content: Text(
              "A verification email has been sent. Please verify your email address before logging in."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      print("Error registering with email: $e");
    }
  }

  // Sign in user with Email and Password
  Future<void> signInWithEmail() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      print("User signed in: ${userCredential.user?.email}");

      // Check if email is verified
      if (userCredential.user?.emailVerified ?? false) {
        print("Email is verified!");
      } else {
        print("Email is not verified. Please verify your email.");
        // Optionally, send another verification email
        await userCredential.user?.sendEmailVerification();
        print("Verification email sent again.");
      }
    } catch (e) {
      print("Error signing in with email: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Email Authentication Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Email Authentication
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Enter Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Enter Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: registerWithEmail,
              child: Text('Register with Email'),
            ),
            ElevatedButton(
              onPressed: signInWithEmail,
              child: Text('Sign In with Email'),
            ),
          ],
        ),
      ),
    );
  }
}
