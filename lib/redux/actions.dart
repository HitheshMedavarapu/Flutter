import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux/redux.dart';
import 'app_state.dart';

// Authentication Actions
class SetUserAction {
  final String? userId;
  SetUserAction(this.userId);
}

// User Profile Actions
class SetUserProfileAction {
  final Map<String, dynamic> userProfile;
  SetUserProfileAction(this.userProfile);
}

Future<void> fetchUserProfile(Store<AppState> store) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    if (userDoc.exists) {
      store.dispatch(
          SetUserProfileAction(userDoc.data() as Map<String, dynamic>));
    }
  }
}

// Chats Actions
class SetChatsAction {
  final List<Map<String, dynamic>> chats;
  SetChatsAction(this.chats);
}

Future<void> fetchChats(Store<AppState> store) async {
  String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  if (currentUserId == null) return;

  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('chats')
      .where('users', arrayContains: currentUserId)
      .orderBy('lastMessageTime', descending: true)
      .get();

  List<Map<String, dynamic>> chatList =
      snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

  store.dispatch(SetChatsAction(chatList));
}

// Marketplace Actions
class SetMarketplaceAction {
  final List<Map<String, dynamic>> marketplace;
  SetMarketplaceAction(this.marketplace);
}

Future<void> fetchMarketplace(Store<AppState> store) async {
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('marketplace').get();
  List<Map<String, dynamic>> marketplaceItems =
      snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

  store.dispatch(SetMarketplaceAction(marketplaceItems));
}

// Theme Mode Actions
class SetThemeModeAction {
  final bool darkMode;
  SetThemeModeAction(this.darkMode);
}

// Settings Actions
class SetNotificationsAction {
  final bool chatNotifications;
  final bool groupChatNotifications;
  final bool suggestions;
  final bool promotions;

  SetNotificationsAction({
    required this.chatNotifications,
    required this.groupChatNotifications,
    required this.suggestions,
    required this.promotions,
  });
}
