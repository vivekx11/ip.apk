import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../models/user_model.dart';

/// Demo authentication service for testing without Firebase
/// Use this when you want to test the app without setting up Firebase
class DemoAuthService {
  static final DemoAuthService _instance = DemoAuthService._internal();
  factory DemoAuthService() => _instance;
  DemoAuthService._internal();

  UserModel? _currentUser;
  String? _lastPhoneNumber;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<void> sendOTP(String phoneNumber) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    _lastPhoneNumber = phoneNumber;
    
    // In demo mode, we just store the phone number
    // In real implementation, this would trigger SMS
    print('🔥 DEMO MODE: OTP sent to $phoneNumber');
    print('🔥 DEMO MODE: Use any 6-digit code to verify (e.g., 123456)');
    print('🔥 DEMO MODE: This is not a real SMS - any 6-digit code will work!');
    
    // You could also show a snackbar or dialog to inform the user
    // that this is demo mode and any 6-digit code will work
  }

  Future<UserModel> verifyOTP(String phoneNumber, String otp) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    if (_lastPhoneNumber != phoneNumber) {
      throw Exception('Phone number mismatch. Please request OTP again.');
    }
    
    if (otp.length != 6) {
      throw Exception('Invalid OTP. Please enter a 6-digit code.');
    }
    
    // In demo mode, accept any 6-digit OTP
    _currentUser = UserModel(
      id: 'demo_${phoneNumber.replaceAll('+', '').replaceAll(' ', '')}',
      phoneNumber: phoneNumber,
      name: 'Demo User',
      email: 'demo@example.com',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Save user data locally
    await _saveUserData(_currentUser!.toJson());
    
    print('Demo: User logged in successfully');
    return _currentUser!;
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? address,
  }) async {
    if (_currentUser == null) throw Exception('User not logged in');

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Update local user model
    _currentUser = _currentUser!.copyWith(
      name: name ?? _currentUser!.name,
      email: email ?? _currentUser!.email,
      address: address ?? _currentUser!.address,
      updatedAt: DateTime.now(),
    );

    await _saveUserData(_currentUser!.toJson());
    print('Demo: Profile updated successfully');
  }

  Future<void> loadSavedAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString(AppConstants.userKey);

      if (userDataString != null) {
        final userData = jsonDecode(userDataString);
        _currentUser = UserModel.fromJson(userData);
        print('Demo: User session restored');
      }
    } catch (e) {
      // Handle error silently, user will need to login again
      await logout();
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.userKey);
      await prefs.remove(AppConstants.cartKey);
      
      _currentUser = null;
      _lastPhoneNumber = null;
      
      print('Demo: User logged out successfully');
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.userKey, jsonEncode(userData));
  }
}