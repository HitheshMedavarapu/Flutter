import 'package:redux/redux.dart';
import 'auth/auth_reducer.dart';
import 'auth/auth_state.dart';

final Store<AppState> store = Store<AppState>(
  appReducer,
  initialState: AppState.initialState(),
);
