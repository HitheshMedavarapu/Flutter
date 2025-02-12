import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = "Unif1";
  static const String defaultProfilePic =
      "https://example.com/default-profile.png";
  static const String defaultGroupIcon =
      "https://example.com/default-group.png";

  // Colors
  static const Color primaryColor = Colors.blue;
  static const Color accentColor = Colors.orange;
  static const Color backgroundColor = Colors.white;
  static const Color textColor = Colors.black;

  // Firebase Collection Names
  static const String usersCollection = "users";
  static const String chatsCollection = "chats";
  static const String messagesCollection = "messages";
  static const String groupChatsCollection = "groupChats";
  static const String postsCollection = "posts";
  static const String marketplaceCollection = "marketplace";

  // Shared Preferences Keys
  static const String themeModeKey = "themeMode";
  static const String notificationsEnabledKey = "notificationsEnabled";
}
