import 'package:redux/redux.dart';
import '../../models/user_model.dart';
import 'auth_actions.dart';

// Define initial state as null (no user logged in)
final UserModel? initialUserState = null;

// Reducer function to handle authentication actions
UserModel? authReducer(UserModel? state, dynamic action) {
  if (action is SetUserAction) {
    return action.user; // Update state with the new user
  } else if (action is ClearUserAction) {
    return null; // Clear user data on logout
  }
  return state;
}
