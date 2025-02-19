class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String profilePic;
  final String city;
  final String college;
  final Map<String, dynamic> preferences;
  final String visaStatus;
  final String userType;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.profilePic,
    required this.city,
    required this.college,
    required this.preferences,
    required this.visaStatus,
    required this.userType,
  });

  // Convert UserModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'profilePic': profilePic,
      'city': city,
      'college': college,
      'preferences': preferences,
      'visaStatus': visaStatus,
      'userType': userType,
    };
  }

  // Create a UserModel from Firestore data
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      profilePic: data['profilePic'] ?? '',
      city: data['city'] ?? '',
      college: data['college'] ?? '',
      preferences: data['preferences'] ?? {},
      visaStatus: data['visaStatus'] ?? '',
      userType: data['userType'] ?? 'student',
    );
  }
}
