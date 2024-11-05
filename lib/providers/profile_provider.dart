// lib/providers/profile_provider.dart

import 'package:flutter/material.dart';
import '../models/profile_data.dart';

class ProfileProvider with ChangeNotifier {
  ProfileData _profileData = ProfileData();

  ProfileData get profileData => _profileData;

  void updateProfile(String name, String university, String email, String address, String phoneNumber) {
    _profileData.name = name;
    _profileData.university = university;
    _profileData.email = email;
    _profileData.address = address;
    _profileData.phoneNumber = phoneNumber;
    notifyListeners();
  }
}
