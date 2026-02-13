import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

/// Simple username-based authentication service (No OTP required)
class SimpleAuthService {
  static final SimpleAuthService _instance = SimpleAuthService._internal();
  factory SimpleAuthService() => _instance;
  SimpleAuthService._internal();

  static const String _userKey = 'simple_user_data';
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  /// Login with just username (no password/OTP)
  Future<UserModel> loginWithUsername(String username) async {
    if (username.trim().isEmpty) {
      throw Exception('Please enter a username');
    }

    // Create user model
    _currentUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      phoneNumber: '', // Not required
      name: username.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Save to local storage
    await _saveUserData();
    return _currentUser!;
  }

  /// Load saved user data
  Future<UserModel?> loadSavedAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString(_userKey);

      if (userDataString != null) {
        final userData = jsonDecode(userDataString);
        _currentUser = UserModel.fromJson(userData);
        return _currentUser;
      }
      return null;
    } catch (e) {
      print('Error loading saved auth: $e');
      return null;
    }
  }

  /// Update user profile
  Future<void> updateProfile({
    String? name,
    String? email,
    String? address,
  }) async {
    if (_currentUser == null) throw Exception('User not logged in');

    _currentUser = _currentUser!.copyWith(
      name: name ?? _currentUser!.name,
      email: email ?? _currentUser!.email,
      address: address ?? _currentUser!.address,
      updatedAt: DateTime.now(),
    );

    await _saveUserData();
  }

  /// Logout
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      _currentUser = null;
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  /// Save user data to local storage
  Future<void> _saveUserData() async {
    if (_currentUser == null) return;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(_currentUser!.toJson()));
  }
}
