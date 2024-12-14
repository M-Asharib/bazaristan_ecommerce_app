import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> setPhoneAuthSettings() async {
    try {
      // Example for Firebase phone authentication settings
      FirebaseAuth auth = FirebaseAuth.instance;

      // Enable or disable reCAPTCHA verification
      bool appVerificationDisabledForTesting =
          true; // Set this to true for testing without SMS
      String? userAccessGroup =
          "yourUserGroup"; // Specify your user access group if needed
      String? phoneNumber =
          "+923152064341"; // The phone number you're testing with
      String? smsCode = "123456"; // Your OTP code for testing

      // Firebase Phone Auth Settings:
      await auth.setSettings(
        appVerificationDisabledForTesting: appVerificationDisabledForTesting,
        userAccessGroup: userAccessGroup,
        phoneNumber: phoneNumber,
        smsCode: smsCode,
        forceRecaptchaFlow:
            false, // This would allow or disallow force reCAPTCHA flow
      );

      print("Phone Authentication settings updated.");
    } catch (e) {
      print("Error setting phone auth settings: $e");
    }
  }

  Future<void> _sendResetEmail() async {
    try {
      final email = _emailController.text.trim();
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // Show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset email sent to $email.')),
      );

      // Navigate to OTP page (optional)
      Navigator.pushNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Enter your email to receive a password reset link.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _sendResetEmail();
                  }
                },
                child: Text('Send Email'),
              ),
              ElevatedButton(
                onPressed: () {
                  // if (_formKey.currentState?.validate() ?? false) {
                  setPhoneAuthSettings();
                  // }
                },
                child: Text('Send SMS'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
