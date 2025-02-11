import 'package:firebase1/firebase_options.dart';
import 'package:firebase1/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure binding before Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // If using FlutterFire CLI
  );
  runApp(MyApp());
}

//actual app starts here.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unif1',
      home: LoginScreen(),
    );
  }
}
