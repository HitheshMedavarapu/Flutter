import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../redux/store.dart';
import '../../redux/auth/auth_actions.dart';
import '../../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isEditing = false;
  String? _editingField;
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  void _logout(BuildContext context) {
    FirebaseAuth.instance.signOut();
    StoreProvider.of<AppState>(context).dispatch(ClearUserAction());

    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  Future<void> _updateField(String fieldName, String value) async {
    String userId = _auth.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      fieldName: value,
    });

    setState(() {
      _isEditing = false;
      _editingField = null;
    });
  }

  Future<void> _pickAndUploadProfilePic() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() => _isUploading = true);

    File file = File(image.path);
    String fileName = 'profile_pictures/${_auth.currentUser!.uid}.jpg';

    UploadTask uploadTask =
        FirebaseStorage.instance.ref().child(fileName).putFile(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .update({
      'profilePic': downloadUrl,
    });

    setState(() => _isUploading = false);
  }

  Widget _buildEditableField(String label, String value, String fieldName) {
    return ListTile(
      title: Text(label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      subtitle: _isEditing && _editingField == fieldName
          ? TextField(
              controller: _controller,
              autofocus: true,
              onSubmitted: (newValue) {
                if (newValue.trim().isNotEmpty) {
                  _updateField(fieldName, newValue.trim());
                }
              },
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(Icons.check, color: Colors.green),
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      _updateField(fieldName, _controller.text.trim());
                    }
                  },
                ),
              ),
            )
          : Text(value, style: const TextStyle(fontSize: 18)),
      trailing: IconButton(
        icon: const Icon(Icons.edit, color: Colors.blue),
        onPressed: () {
          setState(() {
            _isEditing = true;
            _editingField = fieldName;
            _controller.text = value;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserModel?>(
      converter: (store) => store.state.user,
      builder: (context, user) {
        return Scaffold(
          appBar: AppBar(title: const Text("Profile")),
          body: user == null
              ? const Center(child: Text("No user data available"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: user.profilePic.isNotEmpty
                                  ? NetworkImage(user.profilePic)
                                  : const AssetImage(
                                          'assets/default_avatar.png')
                                      as ImageProvider,
                            ),
                            if (_isUploading)
                              const Positioned.fill(
                                child:
                                    Center(child: CircularProgressIndicator()),
                              ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: IconButton(
                                icon: const Icon(Icons.camera_alt,
                                    color: Colors.blue),
                                onPressed: _pickAndUploadProfilePic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildEditableField("Name", user.name, "name"),
                      _buildEditableField("Email", user.email, "email"),
                      _buildEditableField("Phone", user.phone, "phone"),
                      _buildEditableField("City", user.city, "city"),
                      _buildEditableField("College", user.college, "college"),
                      _buildEditableField(
                          "Visa Status", user.visaStatus, "visaStatus"),
                      _buildEditableField(
                          "User Type", user.userType, "userType"),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => _logout(context),
                          child: const Text("Logout"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
