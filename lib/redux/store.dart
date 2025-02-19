import 'package:redux/redux.dart';
import 'auth/auth_reducer.dart';
import '../models/user_model.dart';

// Define AppState to hold the user state
class AppState {
  final UserModel? user;

  AppState({this.user});

  AppState copyWith({UserModel? user}) {
    return AppState(user: user ?? this.user);
  }
}

// Combine reducers (for now, only authReducer)
AppState appReducer(AppState state, dynamic action) {
  return AppState(
    user: authReducer(state.user, action),
  );
}

// Create Redux store
final Store<AppState> store = Store<AppState>(
  appReducer,
  initialState: AppState(user: null),
);
