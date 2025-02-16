import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔹 SIGN UP FUNCTION (Automatically Saves User to Firestore)
  Future<User?> signUp(
      String name, String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        // Save user details in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name.trim(),
          'email': email.trim(),
          'profilePicture': "", // Placeholder, user can update later
          'friends': [], // Empty friend list initially
          'city': "",
          'college': "",
          'interests': [],
          'preferences': [],
        });
      }

      return user;
    } catch (e) {
      print("Sign Up Error: $e");
      return null;
    }
  }

  // 🔹 SIGN IN FUNCTION
  Future<void> signIn(
      String email, String password, BuildContext context) async {
    try {
      // Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      String uid = userCredential.user!.uid; // Get UID of logged-in user

      // 🔥 Fetch user data from Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        // 🔹 Store user data in Provider
        // Ensure you have a UserProvider listening to the context
        // Provider.of<UserProvider>(context, listen: false).loadUserData();
      } else {
        print("User document not found!");
      }
    } catch (e) {
      print("Login Failed: $e");
    }
  }

  // 🔹 SIGN OUT FUNCTION
  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    // Provider.of<UserProvider>(context, listen: false).signOut(); // Uncomment if using UserProvider
  }
}
