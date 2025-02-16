import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../redux/app_state.dart';
import '../../redux/actions.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    StoreProvider.of<AppState>(context).dispatch(SetUserAction(null));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Map<String, dynamic>?>(
      converter: (store) => store.state.userProfile,
      builder: (context, userProfile) {
        if (userProfile == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          appBar: AppBar(title: const Text("Profile")),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: userProfile['profilePicture'] != null
                      ? NetworkImage(userProfile['profilePicture'])
                      : null,
                  child: userProfile['profilePicture'] == null
                      ? const Icon(Icons.person, size: 50)
                      : null,
                ),
                const SizedBox(height: 10),
                Text(userProfile['name'] ?? "No Name",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(userProfile['email'] ?? "No Email",
                    style: const TextStyle(fontSize: 16, color: Colors.grey)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _logout(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Log Out",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
