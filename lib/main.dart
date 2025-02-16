import 'package:firebase1/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/auth/login_screen.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'redux/store.dart';
import 'redux/auth/auth_state.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures Firebase initializes properly
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Unif1',
        home: StoreConnector<AppState, bool>(
          converter: (store) => store.state.authState.isAuthenticated,
          builder: (context, isAuthenticated) {
            return isAuthenticated ? HomeScreen() : LoginScreen();
          },
        ),
      ),
    );
  }
}
