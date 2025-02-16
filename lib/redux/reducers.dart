import 'app_state.dart';
import 'actions.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is SetUserAction) {
    return state.copyWith(userId: action.userId);
  } else if (action is SetUserProfileAction) {
    return state.copyWith(userProfile: action.userProfile);
  } else if (action is SetChatsAction) {
    return state.copyWith(chats: action.chats);
  } else if (action is SetMarketplaceAction) {
    return state.copyWith(marketplace: action.marketplace);
  } else if (action is SetThemeModeAction) {
    return state.copyWith(darkMode: action.darkMode);
  } else if (action is SetNotificationsAction) {
    return state.copyWith(
      chatNotifications: action.chatNotifications,
      groupChatNotifications: action.groupChatNotifications,
      suggestions: action.suggestions,
      promotions: action.promotions,
    );
  }
  return state;
}
