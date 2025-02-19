import 'package:flutter/material.dart';

@immutable
class ProfileState {
  final String uid;
  final String name;
  final String email;
  final String profilePicture;
  final String city;
  final String college;
  final List<String> interests;
  final List<String> preferences;

  const ProfileState({
    required this.uid,
    required this.name,
    required this.email,
    required this.profilePicture,
    required this.city,
    required this.college,
    required this.interests,
    required this.preferences,
  });

  // ✅ Initial state with default values
  factory ProfileState.initial() {
    return const ProfileState(
      uid: "",
      name: "",
      email: "",
      profilePicture: "",
      city: "",
      college: "",
      interests: [],
      preferences: [],
    );
  }

  // ✅ Copy method to update Redux state
  ProfileState copyWith({
    String? uid,
    String? name,
    String? email,
    String? profilePicture,
    String? city,
    String? college,
    List<String>? interests,
    List<String>? preferences,
  }) {
    return ProfileState(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      city: city ?? this.city,
      college: college ?? this.college,
      interests: interests ?? this.interests,
      preferences: preferences ?? this.preferences,
    );
  }

  @override
  String toString() {
    return "ProfileState(uid: $uid, name: $name, email: $email, profilePicture: $profilePicture, city: $city, college: $college, interests: $interests, preferences: $preferences)";
  }
}
