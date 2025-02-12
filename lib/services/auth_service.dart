import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔹 SIGN IN FUNCTION
  Future<void> signIn(
      String email, String password, BuildContext context) async {
    try {
      // Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid; // Get UID of logged-in user

      // 🔥 Fetch user data from Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        // 🔹 Store user data in Provider
        Provider.of<UserProvider>(context, listen: false)
            .setUserData(userDoc.data() as Map<String, dynamic>);

        // Navigate to Home Page
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        print("User document not found!");
      }
    } catch (e) {
      print("Login Failed: $e");
    }
  }
}
