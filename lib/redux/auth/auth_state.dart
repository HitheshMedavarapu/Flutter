class AuthState {
  final String? uid;
  final String? email;
  final bool isAuthenticated;

  AuthState({this.uid, this.email, this.isAuthenticated = false});

  AuthState copyWith({String? uid, String? email, bool? isAuthenticated}) {
    return AuthState(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }

  static AuthState initialState() {
    return AuthState(isAuthenticated: false);
  }
}

class AppState {
  final AuthState authState;

  AppState({required this.authState});

  static AppState initialState() {
    return AppState(authState: AuthState.initialState());
  }
}
