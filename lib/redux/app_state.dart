import 'package:flutter/material.dart';

class AppState {
  final String? userId;
  final Map<String, dynamic>? userProfile;
  final List<Map<String, dynamic>> chats;
  final List<Map<String, dynamic>> groupChats;
  final List<Map<String, dynamic>> marketplace;
  final bool darkMode;
  final bool chatNotifications;
  final bool groupChatNotifications;
  final bool suggestions;
  final bool promotions;

  AppState({
    required this.userId,
    required this.userProfile,
    required this.chats,
    required this.groupChats,
    required this.marketplace,
    required this.darkMode,
    required this.chatNotifications,
    required this.groupChatNotifications,
    required this.suggestions,
    required this.promotions,
  });

  AppState.initialState()
      : userId = null,
        userProfile = null,
        chats = [],
        groupChats = [],
        marketplace = [],
        darkMode = false,
        chatNotifications = true,
        groupChatNotifications = true,
        suggestions = true,
        promotions = false;

  AppState copyWith({
    String? userId,
    Map<String, dynamic>? userProfile,
    List<Map<String, dynamic>>? chats,
    List<Map<String, dynamic>>? groupChats,
    List<Map<String, dynamic>>? marketplace,
    bool? darkMode,
    bool? chatNotifications,
    bool? groupChatNotifications,
    bool? suggestions,
    bool? promotions,
  }) {
    return AppState(
      userId: userId ?? this.userId,
      userProfile: userProfile ?? this.userProfile,
      chats: chats ?? this.chats,
      groupChats: groupChats ?? this.groupChats,
      marketplace: marketplace ?? this.marketplace,
      darkMode: darkMode ?? this.darkMode,
      chatNotifications: chatNotifications ?? this.chatNotifications,
      groupChatNotifications:
          groupChatNotifications ?? this.groupChatNotifications,
      suggestions: suggestions ?? this.suggestions,
      promotions: promotions ?? this.promotions,
    );
  }
}
