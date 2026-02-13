// Auth service - Using simple auth instead of Firebase
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  UserModel? _currentUser;
  String? _verificationId;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  // Simple OTP simulation for demo
  Future<void> sendOTP(String phoneNumber) async {
    // Simulate OTP send
    _verificationId = '123456';
    print('📱 OTP sent to: $phoneNumber (Demo mode)');
  }

  Future<UserModel?> verifyOTP(String phoneNumber, String otp) async {
    // Simple verification for demo
    if (otp == '123456' || otp.length == 6) {
      _currentUser = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        phoneNumber: phoneNumber,
        name: 'User',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _saveUser(_currentUser!);
      return _currentUser;
    }
    throw Exception('Invalid OTP');
  }
  
  Future<void> updateProfile({String? name, String? email, String? address}) async {
    if (_currentUser != null) {
      _currentUser = UserModel(
        id: _currentUser!.id,
        phoneNumber: _currentUser!.phoneNumber,
        name: name ?? _currentUser!.name,
        email: email ?? _currentUser!.email,
        address: address ?? _currentUser!.address,
        createdAt: _currentUser!.createdAt,
        updatedAt: DateTime.now(),
      );
      await _saveUser(_currentUser!);
    }
  }

  Future<void> _saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', json.encode(user.toJson()));
  }

  Future<UserModel?> loadSavedAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      if (userData != null) {
        _currentUser = UserModel.fromJson(json.decode(userData));
        return _currentUser;
      }
    } catch (e) {
      print('Error loading saved auth: $e');
    }
    return null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    _currentUser = null;
  }
}
