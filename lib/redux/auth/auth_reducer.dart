import 'auth_state.dart';
import 'auth_actions.dart';

AuthState authReducer(AuthState state, dynamic action) {
  if (action is LoginAction) {
    return state.copyWith(
        uid: action.uid, email: action.email, isAuthenticated: true);
  }
  if (action is LogoutAction) {
    return AuthState.initialState();
  }
  return state;
}

AppState appReducer(AppState state, dynamic action) {
  return AppState(authState: authReducer(state.authState, action));
}
