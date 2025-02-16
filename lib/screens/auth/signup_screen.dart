import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../redux/auth/auth_actions.dart';
import '../../redux/auth/auth_state.dart';
import '../home/home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  String? _errorMessage;

  void _signUp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Validate password match
    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      setState(() {
        _errorMessage = "Passwords do not match!";
        _isLoading = false;
      });
      return;
    }

    try {
      // Create user in Firebase Auth
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Save user data to Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'profilePicture': '',
        'description': '',
        'interests': '',
        'city': '',
        'college': '',
        'preferences': '',
      });

      // Force user logout after account creation
      await _auth.signOut();

      // Show success message and redirect to LoginScreen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Account created successfully! Please log in.")),
      );

      // Navigate to LoginScreen and clear the stack
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false, // Removes all previous routes
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Full Name")),
            const SizedBox(height: 10),
            TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email")),
            const SizedBox(height: 10),
            TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password")),
            const SizedBox(height: 10),
            TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: "Re-enter Password")),
            const SizedBox(height: 10),
            if (_errorMessage != null)
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _signUp, child: const Text("Sign Up")),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Go back to login screen
              },
              child: const Text("Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}
