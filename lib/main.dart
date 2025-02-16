import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'firebase_options.dart';
import 'redux/app_state.dart';
import 'redux/reducers.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final store = Store<AppState>(
    appReducer,
    initialState: AppState.initialState(),
  );

  runApp(MyApp(store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;
  const MyApp(this.store, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Unif1',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        home: AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) {
          return const HomeScreen(); // User is logged in
        }
        return const LoginScreen(); // User is NOT logged in
      },
    );
  }
}
