class UserModel {
  final String uid;
  final String name;
  final String email;
  final String profilePicture;
  final String description;
  final List<String> interests;
  final String city;
  final String college;
  final List<String> preferences;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.profilePicture,
    required this.description,
    required this.interests,
    required this.city,
    required this.college,
    required this.preferences,
  });

  // Convert a UserModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profilePicture': profilePicture,
      'description': description,
      'interests': interests,
      'city': city,
      'college': college,
      'preferences': preferences,
    };
  }

  // Create a UserModel from a Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profilePicture: map['profilePicture'] ?? '',
      description: map['description'] ?? '',
      interests: List<String>.from(map['interests'] ?? []),
      city: map['city'] ?? '',
      college: map['college'] ?? '',
      preferences: List<String>.from(map['preferences'] ?? []),
    );
  }
}
