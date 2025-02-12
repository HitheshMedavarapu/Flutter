class PostModel {
  final String postId;
  final String userId;
  final String username;
  final String profileImage;
  final String content;
  final String? imageUrl;
  final DateTime timestamp;
  final int usefulCount;
  final int notUsefulCount;
  final bool isPublic;

  PostModel({
    required this.postId,
    required this.userId,
    required this.username,
    required this.profileImage,
    required this.content,
    this.imageUrl,
    required this.timestamp,
    required this.usefulCount,
    required this.notUsefulCount,
    required this.isPublic,
  });

  // Convert a PostModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'userId': userId,
      'username': username,
      'profileImage': profileImage,
      'content': content,
      'imageUrl': imageUrl,
      'timestamp': timestamp.toIso8601String(),
      'usefulCount': usefulCount,
      'notUsefulCount': notUsefulCount,
      'isPublic': isPublic,
    };
  }

  // Create a PostModel from a Map
  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postId: map['postId'] ?? '',
      userId: map['userId'] ?? '',
      username: map['username'] ?? '',
      profileImage: map['profileImage'] ?? '',
      content: map['content'] ?? '',
      imageUrl: map['imageUrl'],
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp']) ?? DateTime.now()
          : DateTime.now(),
      usefulCount: map['usefulCount'] ?? 0,
      notUsefulCount: map['notUsefulCount'] ?? 0,
      isPublic: map['isPublic'] ?? true,
    );
  }
}
