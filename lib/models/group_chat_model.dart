class GroupChatModel {
  final String groupId;
  final String groupName;
  final String groupIcon;
  final List<String> participants;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  GroupChatModel({
    required this.groupId,
    required this.groupName,
    required this.groupIcon,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });

  // Convert a GroupChatModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'groupName': groupName,
      'groupIcon': groupIcon,
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'unreadCount': unreadCount,
    };
  }

  // Create a GroupChatModel from a Map
  factory GroupChatModel.fromMap(Map<String, dynamic> map) {
    return GroupChatModel(
      groupId: map['groupId'] ?? '',
      groupName: map['groupName'] ?? '',
      groupIcon: map['groupIcon'] ?? '',
      participants: List<String>.from(map['participants'] ?? []),
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: map['lastMessageTime'] != null
          ? DateTime.tryParse(map['lastMessageTime']) ?? DateTime.now()
          : DateTime.now(),
      unreadCount: map['unreadCount'] ?? 0,
    );
  }
}
