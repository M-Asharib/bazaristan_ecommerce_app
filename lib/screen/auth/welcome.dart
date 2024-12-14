import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Text(
              "Welcome",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // CircleAvatar(
            //   radius: 50,
            //   backgroundColor: Colors.green, // Outer green circle
            //   child: CircleAvatar(
            //     radius: 45, // Inner white circle
            //     backgroundColor: Colors.white,
            //     child: Icon(
            //       Icons.person, // Replace with the desired icon
            //       size: 80,
            //       color: Colors.green, // Icon color
            //     ),
            //   ),
            // ),
            Center(
              child: Container(
                child: Image.asset(
                  'assets/images/wel_icon.png', // Replace with the correct asset path
                  // width: 0,
                  height: 150,
                  fit: BoxFit
                      .cover, // Ensures the image is cropped and fits in the circle
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "Welcome to bazaristan, please login or signup to continue",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                GoRouter.of(context).go('/signin');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
              ),
              child: const Text(
                "Sign in or create",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center the row
              children: [
                const Text(
                  "use your google account",
                  style: TextStyle(fontSize: 8, color: Colors.black),
                ),
                const SizedBox(width: 5), // Space between texts
                GestureDetector(
                  onTap: () {
                    // Navigate to the signup page or perform an action
                    print("help now");
                    // GoRouter.of(context).go('/signup');
                  },
                  child: const Text(
                    "Need any Help?",
                    style: TextStyle(
                      fontSize: 8,
                      color: Colors.black, // Highlight the clickable text
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            // TextButton(
            //   onPressed: () {},
            //   child: const Text(
            //     "Need any Help?",
            //     style: TextStyle(color: Colors.green),
            //   ),
            // ),

            const Spacer(),
            Image.network(
              "https://upload.wikimedia.org/wikipedia/commons/4/4a/Logo_2013_Google.png",
              height: 25,
            ),
            const SizedBox(height: 10),
            const Text.rich(
              TextSpan(
                text: "By continuing, you agree to the ",
                style: TextStyle(color: Colors.grey, fontSize: 12),
                children: [
                  TextSpan(
                    text: "Terms of Use",
                    style: TextStyle(color: Colors.blue),
                  ),
                  TextSpan(text: " and "),
                  TextSpan(
                    text: "Privacy Statement",
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
