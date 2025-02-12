class ChatModel {
  final String chatId;
  final List<String> participants;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isGroupChat;

  ChatModel({
    required this.chatId,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.isGroupChat,
  });

  // Convert a ChatModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'unreadCount': unreadCount,
      'isGroupChat': isGroupChat,
    };
  }

  // Create a ChatModel from a Map
  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      chatId: map['chatId'] ?? '',
      participants: List<String>.from(map['participants'] ?? []),
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: map['lastMessageTime'] != null
          ? DateTime.tryParse(map['lastMessageTime']) ?? DateTime.now()
          : DateTime.now(),
      unreadCount: map['unreadCount'] ?? 0,
      isGroupChat: map['isGroupChat'] ?? false,
    );
  }
}
