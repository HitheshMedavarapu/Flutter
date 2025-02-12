import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic>? _userData;

  Map<String, dynamic>? get userData => _userData;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Load user data from Firestore
  Future<void> loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        _userData = userDoc.data() as Map<String, dynamic>;
        notifyListeners();
      }
    }
  }

  // Set user data manually (Used in AuthService)
  void setUserData(Map<String, dynamic> data) {
    _userData = data;
    notifyListeners();
  }

  // Sign out function
  Future<void> signOut() async {
    await _auth.signOut();
    _userData = null;
    notifyListeners();
  }
}
