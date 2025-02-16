import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'otp_verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _errorMessage;
  bool _isLoading = false;

  // Generate a 4-digit OTP
  String generateOTP() {
    final random = Random();
    return (1000 + random.nextInt(9000)).toString();
  }

  Future<void> _sendOTP() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      String otp = generateOTP();
      String recipientEmail = _emailController.text.trim();

      // Sendinblue SMTP Configuration (Real email sending)
      final smtpServer = SmtpServer(
        'smtp-relay.brevo.com', // Sendinblue SMTP Host
        port: 587, // Use 587 for TLS or 465 for SSL
        username: '85e477001@smtp-brevo.com', // Your Sendinblue email
        password: 'R0OUYkSM3Gw4C5sm', // Your Sendinblue SMTP password
        ssl: false, // Ensure TLS is used
        ignoreBadCertificate: false, // Check SSL certificates
      );

      final message = Message()
        ..from = Address(
            'oneunif@gmail.com', 'Unif1 App') // Use your verified sender email
        ..recipients.add(recipientEmail)
        ..subject = 'Your OTP Code'
        ..text = 'Your OTP code is: $otp. It is valid for 5 minutes.';

      print("📩 Sending OTP email to: $recipientEmail...");

      try {
        final sendReport = await send(message, smtpServer);
        print("✅ Email sent successfully: ${sendReport.toString()}");

        // Navigate to OTP verification screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OTPVerificationScreen(email: recipientEmail, otp: otp),
          ),
        );
      } catch (e) {
        print("❌ Email sending failed: $e");
        setState(() {
          _errorMessage = "Failed to send OTP. Check logs for details.";
        });
      }
    } catch (e) {
      print("❌ Unexpected Error: $e");
      setState(() {
        _errorMessage = "An error occurred. Please try again.";
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
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
                controller: _emailController,
                decoration:
                    const InputDecoration(labelText: "Enter your email")),
            const SizedBox(height: 10),
            if (_errorMessage != null)
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _sendOTP, child: const Text("Send OTP")),
          ],
        ),
      ),
    );
  }
}
