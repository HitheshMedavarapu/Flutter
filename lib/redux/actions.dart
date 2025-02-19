import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux/redux.dart';
import 'app_state.dart' as app; // ✅ Ensuring alias is correctly defined
import 'profile/profile_state.dart' as profile; // ✅ Alias ProfileState

// 🔹 Authentication Actions
class SetUserAction {
  final String? userId;
  SetUserAction(this.userId);
}

// 🔹 User Profile Actions
class SetUserProfileAction {
  final profile.ProfileState profileState;
  SetUserProfileAction(this.profileState);
}

Future<void> fetchUserProfile(Store<app.AppState> store) async {
  print("📌 Redux: Fetching user profile...");

  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print("❌ No authenticated user found.");
    return;
  }

  String uid = user.uid;
  print("✅ Firebase UID: $uid");

  try {
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists && userDoc.data() != null) {
      if (userDoc.exists && userDoc.data() != null) {
        print("✅ Firestore Data Retrieved: ${userDoc.data()}");
      } else {
        print("❌ Firestore user document NOT FOUND for UID: $uid");
      }
      var data = userDoc.data()!;
      profile.ProfileState profileData = profile.ProfileState(
        uid: uid,
        name: data['name'] ?? "No Name",
        email: data['email'] ?? "No Email",
        profilePicture: data['profilePicture'] ?? "",
        city: data['city'] ?? "No City",
        college: data['college'] ?? "No College",
        interests: (data['interests'] as List?)?.cast<String>() ?? [],
        preferences: (data['preferences'] as List?)?.cast<String>() ?? [],
      );

      print("✅ Dispatching Redux Action for Profile: $profileData");
      store.dispatch(SetUserProfileAction(profileData));
      print("✅ Profile successfully dispatched to Redux store.");
    } else {
      print("❌ Firestore user document not found!");
    }
  } catch (e) {
    print("❌ Error Fetching Profile: $e");
  }
}

// 🔹 Logout Action
class LogoutAction {}

Future<void> logoutUser(Store<app.AppState> store) async {
  print("📌 Logging Out...");
  await FirebaseAuth.instance.signOut();
  print("✅ User Signed Out");

  store.dispatch(LogoutAction());
}
