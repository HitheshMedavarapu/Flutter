import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic>? _userData;
  List<Map<String, dynamic>> _userChats = [];
  List<Map<String, dynamic>> _userGroupChats = [];
  List<Map<String, dynamic>> _friendsPosts = [];
  List<Map<String, dynamic>> _friendsMarketplaceListings = [];
  List<Map<String, dynamic>> _marketplaceListings = [];

  Map<String, dynamic>? get userData => _userData;
  List<Map<String, dynamic>> get userChats => _userChats;
  List<Map<String, dynamic>> get userGroupChats => _userGroupChats;
  List<Map<String, dynamic>> get friendsPosts => _friendsPosts;
  List<Map<String, dynamic>> get friendsMarketplaceListings =>
      _friendsMarketplaceListings;
  List<Map<String, dynamic>> get marketplaceListings => _marketplaceListings;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Load all user data after sign-in
  Future<void> loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        _userData = userDoc.data() as Map<String, dynamic>;
        notifyListeners();
      }

      // Fetch user's chats
      _userChats = await _fetchUserChats(user.uid);
      _userGroupChats = await _fetchUserGroupChats(user.uid);
      _friendsPosts = await _fetchFriendsPosts(user.uid);
      _friendsMarketplaceListings = await _fetchFriendsMarketplace(user.uid);
      _marketplaceListings = await _fetchMarketplaceListings();

      notifyListeners();
    }
  }

  // Fetch One-on-One Chats
  Future<List<Map<String, dynamic>>> _fetchUserChats(String userId) async {
    QuerySnapshot query = await _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .get();

    return query.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  // Fetch Group Chats
  Future<List<Map<String, dynamic>>> _fetchUserGroupChats(String userId) async {
    QuerySnapshot query = await _firestore
        .collection('groupChats')
        .where('members', arrayContains: userId)
        .get();

    return query.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  // Fetch Friends' Posts
  Future<List<Map<String, dynamic>>> _fetchFriendsPosts(String userId) async {
    QuerySnapshot query = await _firestore
        .collection('posts')
        .where('visibility', isEqualTo: 'friends')
        .where('authorId', isNotEqualTo: userId)
        .get();

    return query.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  // Fetch Friends' Marketplace Listings
  Future<List<Map<String, dynamic>>> _fetchFriendsMarketplace(
      String userId) async {
    QuerySnapshot query = await _firestore
        .collection('marketplace')
        .where('visibility', isEqualTo: 'friends')
        .where('sellerId', isNotEqualTo: userId)
        .get();

    return query.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  // Fetch General Marketplace Listings
  Future<List<Map<String, dynamic>>> _fetchMarketplaceListings() async {
    QuerySnapshot query = await _firestore
        .collection('marketplace')
        .where('visibility', isEqualTo: 'public')
        .get();

    return query.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  // Sign out and clear data
  Future<void> signOut() async {
    await _auth.signOut();
    _userData = null;
    _userChats = [];
    _userGroupChats = [];
    _friendsPosts = [];
    _friendsMarketplaceListings = [];
    _marketplaceListings = [];
    notifyListeners();
  }

  void setUserData(Map<String, dynamic> data) {}
}
