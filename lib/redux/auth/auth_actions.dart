import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';

// Action to store user data in Redux
class SetUserAction {
  final UserModel user;
  SetUserAction(this.user);
}

// Action to clear user data on logout
class ClearUserAction {}

// Function to sign up a new user and store details in Firestore & Redux
Future<void> signUpUserAction({
  required String email,
  required String password,
  required String name,
  required String phoneNumber,
  required Function(dynamic) dispatch, // Redux dispatch function
  required Function(String?) onError, // Callback for handling errors
}) async {
  try {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Create user in Firebase Authentication
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;
    if (user != null) {
      // Create user model
      UserModel newUser = UserModel(
        uid: user.uid,
        name: name,
        email: email,
        phone: phoneNumber,
        profilePic: '',
        city: '',
        college: '',
        preferences: {},
        visaStatus: '',
        userType: 'student', // Default to student
      );

      // Store user details in Firestore
      await firestore.collection('users').doc(user.uid).set(newUser.toMap());

      // Dispatch action to update Redux store
      dispatch(SetUserAction(newUser));

      onError(null); // No error, success
    } else {
      onError("User creation failed");
    }
  } on FirebaseAuthException catch (e) {
    onError(e.message);
  }
}

Future<void> createUserFirestoreEntry(User user) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  DocumentReference userRef = firestore.collection('users').doc(user.uid);
  DocumentReference buddyRef = firestore.collection('buddies').doc(user.uid);

  await userRef.set({
    'uid': user.uid,
    'name': user.displayName ?? 'New User',
    'email': user.email ?? '',
    'profilePic': '',
    'buddies': [],
    'requests': [],
    'createdAt': FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));

  // Initialize the buddies collection
  await buddyRef.set({
    'requests': [],
    'buddies': [],
  });
}
