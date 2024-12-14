import 'package:flutter/material.dart';

class OtpVerificationScreen extends StatefulWidget {
  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();

  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();

    // Mock OTP verification
    if (otp == '123456') {
      // Navigate to reset password screen
      Navigator.pushNamed(context, '/resetPassword');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid OTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('OTP Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Text(
            //   'Enter the OTP sent to your email.',
            //   style: TextStyle(fontSize: 16),
            //   textAlign: TextAlign.center,
            // ),
            // SizedBox(height: 16),
            // TextField(
            //   controller: _otpController,
            //   decoration: InputDecoration(labelText: 'OTP'),
            //   keyboardType: TextInputType.number,
            // ),
            // SizedBox(height: 16),
            ElevatedButton(
              onPressed: _verifyOtp,
              child: Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
