import 'profile/profile_state.dart' as profile; // ✅ Fix Import

class AppState {
  final String? userId;
  final profile.ProfileState profileState; // ✅ Include ProfileState
  final List<Map<String, dynamic>> chats;
  final List<Map<String, dynamic>> marketplace;
  final bool darkMode;
  final bool chatNotifications;
  final bool groupChatNotifications;
  final bool suggestions;
  final bool promotions;

  AppState({
    required this.userId,
    required this.profileState,
    required this.chats,
    required this.marketplace,
    required this.darkMode,
    required this.chatNotifications,
    required this.groupChatNotifications,
    required this.suggestions,
    required this.promotions,
  });

  AppState.initialState()
      : userId = null,
        profileState = profile.ProfileState.initial(), // ✅ Fix Profile Default
        chats = [],
        marketplace = [],
        darkMode = false,
        chatNotifications = true,
        groupChatNotifications = true,
        suggestions = true,
        promotions = false;

  AppState copyWith({
    String? userId,
    profile.ProfileState? profileState,
    List<Map<String, dynamic>>? chats,
    List<Map<String, dynamic>>? marketplace,
    bool? darkMode,
    bool? chatNotifications,
    bool? groupChatNotifications,
    bool? suggestions,
    bool? promotions,
  }) {
    return AppState(
      userId: userId ?? this.userId,
      profileState: profileState ?? this.profileState,
      chats: chats ?? this.chats,
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
