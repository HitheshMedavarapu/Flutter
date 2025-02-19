import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔹 SIGN UP FUNCTION
  Future<User?> signUp(
      String name, String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        String uid = user.uid;
        print("✅ Sign-Up Successful: UID = $uid");

        // 🔹 Store user details in Firestore
        await _firestore.collection('users').doc(uid).set({
          'uid': uid,
          'name': name,
          'email': email,
          'profilePicture': '',
          'city': '',
          'college': '',
          'interests': [],
          'preferences': [],
        });

        print("✅ Firestore user profile created for $name ($email)");

        return user;
      }
    } on FirebaseAuthException catch (e) {
      print("❌ Sign-Up Error: ${e.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign-Up Error: ${e.message}")),
      );
    }
    return null;
  }
}
