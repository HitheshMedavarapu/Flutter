import 'app_state.dart';
import 'actions.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is SetUserAction) {
    return state.copyWith(userId: action.userId);
  } else if (action is SetUserProfileAction) {
    print(
        "✅ Reducer: Updating ProfileState: ${action.profileState.toString()}");
    return state.copyWith(profileState: action.profileState);
  } else if (action is LogoutAction) {
    return AppState.initialState(); // ✅ Reset state on logout
  }
  return state;
}
