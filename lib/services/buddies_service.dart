import 'package:cloud_firestore/cloud_firestore.dart';

class BuddiesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Create a buddies document when a new user signs up
  Future<void> createBuddiesEntry(String userId) async {
    DocumentReference buddyRef = _firestore.collection('buddies').doc(userId);

    await buddyRef.set({
      'requests': [],
      'buddies': [],
    }, SetOptions(merge: true));
  }

  /// Send a buddy request to another user
  Future<void> sendBuddyRequest(String senderId, String receiverId) async {
    DocumentReference receiverRef =
        _firestore.collection('buddies').doc(receiverId);

    await receiverRef.update({
      'requests': FieldValue.arrayUnion([senderId])
    });
  }

  /// Accept a buddy request
  Future<void> acceptBuddyRequest(String currentUserId, String senderId) async {
    DocumentReference userRef =
        _firestore.collection('buddies').doc(currentUserId);
    DocumentReference senderRef =
        _firestore.collection('buddies').doc(senderId);

    // Update both users' buddies list
    await userRef.update({
      'buddies': FieldValue.arrayUnion([senderId]),
      'requests': FieldValue.arrayRemove([senderId])
    });

    await senderRef.update({
      'buddies': FieldValue.arrayUnion([currentUserId])
    });

    // Create a chat between them
    await _createChatBetweenUsers(currentUserId, senderId);
  }

  /// Decline a buddy request (remove from requests list)
  Future<void> declineBuddyRequest(
      String currentUserId, String senderId) async {
    DocumentReference userRef =
        _firestore.collection('buddies').doc(currentUserId);

    await userRef.update({
      'requests': FieldValue.arrayRemove([senderId])
    });
  }

  /// Get "Be My Buddy" requests
  Stream<List<String>> getBuddyRequests(String userId) {
    return _firestore
        .collection('buddies')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        List<dynamic> requests = snapshot.data()?['requests'] ?? [];
        return requests.cast<String>();
      }
      return [];
    });
  }

  /// Get list of accepted buddies
  Stream<List<String>> getBuddies(String userId) {
    return _firestore
        .collection('buddies')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        List<dynamic> buddies = snapshot.data()?['buddies'] ?? [];
        return buddies.cast<String>();
      }
      return [];
    });
  }

  /// Create a new chat between two users
  Future<void> _createChatBetweenUsers(String uid1, String uid2) async {
    String chatId = _generateChatId(uid1, uid2);
    DocumentReference chatRef = _firestore.collection('chats').doc(chatId);

    await chatRef.set({
      'users': [uid1, uid2],
      'lastMessage': '',
      'lastMessageTime': FieldValue.serverTimestamp(),
      'unreadCount': {uid1: 0, uid2: 0}
    });
  }

  /// Generate a unique chat ID
  String _generateChatId(String uid1, String uid2) {
    List<String> sortedIds = [uid1, uid2]..sort();
    return sortedIds.join('_');
  }
}
