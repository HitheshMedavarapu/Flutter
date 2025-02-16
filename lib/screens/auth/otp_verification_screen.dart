import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;
  final String otp;

  const OTPVerificationScreen(
      {Key? key, required this.email, required this.otp})
      : super(key: key);

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isOTPVerified = false;
  String? _errorMessage;
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _verifyOTP() {
    if (_otpController.text.trim() == widget.otp) {
      setState(() {
        _isOTPVerified = true; // Show password fields after OTP verification
        _errorMessage = null;
      });
    } else {
      setState(() {
        _errorMessage = "Invalid OTP. Try again.";
      });
    }
  }

  Future<void> _updatePassword() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = "Passwords do not match.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      User? user = _auth.currentUser;

      if (user == null) {
        // Sign the user in anonymously if they are not signed in
        UserCredential anonymousUser = await _auth.signInAnonymously();
        user = anonymousUser.user;
      }

      if (user != null) {
        // Update the password directly
        await user.updatePassword(_passwordController.text);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password updated successfully!")),
        );

        Navigator.pop(context); // Go back after reset
      } else {
        setState(() {
          _errorMessage = "User not found. Please try again.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error updating password: ${e.toString()}";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify OTP")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_isOTPVerified) ...[
              const Text("Enter the OTP sent to your email."),
              TextField(
                controller: _otpController,
                decoration: const InputDecoration(labelText: "Enter OTP"),
              ),
              const SizedBox(height: 10),
              if (_errorMessage != null)
                Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _verifyOTP,
                child: const Text("Verify OTP"),
              ),
            ] else ...[
              const Text("Enter your new password"),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "New Password"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: "Confirm Password"),
              ),
              const SizedBox(height: 10),
              if (_errorMessage != null)
                Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _updatePassword,
                      child: const Text("Update Password"),
                    ),
            ],
          ],
        ),
      ),
    );
  }
}
