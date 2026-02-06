import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../models/user_model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  UserModel? _currentUser;
  String? _verificationId;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<void> sendOTP(String phoneNumber) async {
    try {
      print('🔥 Firebase: Sending OTP to: $phoneNumber');
      
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('🔥 Firebase: Auto-verification completed');
          // Auto-verification completed
          await _signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print('🔥 Firebase: Verification failed: ${e.code} - ${e.message}');
          String errorMessage = 'Verification failed';
          
          switch (e.code) {
            case 'invalid-phone-number':
              errorMessage = 'Invalid phone number format';
              break;
            case 'too-many-requests':
              errorMessage = 'Too many requests. Please try again later';
              break;
            case 'app-not-authorized':
              errorMessage = 'App not authorized. Please check Firebase configuration';
              break;
            case 'network-request-failed':
              errorMessage = 'Network error. Please check your internet connection';
              break;
            default:
              errorMessage = e.message ?? 'Unknown error occurred';
          }
          
          throw Exception(errorMessage);
        },
        codeSent: (String verificationId, int? resendToken) {
          print('🔥 Firebase: OTP sent successfully. Verification ID: $verificationId');
          _verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('🔥 Firebase: Code auto-retrieval timeout. Verification ID: $verificationId');
          _verificationId = verificationId;
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      print('🔥 Firebase: Error sending OTP: $e');
      throw Exception('Failed to send OTP: $e');
    }
  }

  Future<UserModel> verifyOTP(String phoneNumber, String otp) async {
    try {
      print('🔥 Firebase: Verifying OTP: $otp for phone: $phoneNumber');
      
      if (_verificationId == null) {
        throw Exception('Verification ID not found. Please request OTP again.');
      }

      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      print('🔥 Firebase: Signing in with credential...');
      final userCredential = await _signInWithCredential(credential);
      
      print('🔥 Firebase: Sign in successful!');
      return _currentUser!;
    } catch (e) {
      print('🔥 Firebase: Error verifying OTP: $e');
      
      String errorMessage = 'Failed to verify OTP';
      if (e.toString().contains('invalid-verification-code')) {
        errorMessage = 'Invalid OTP. Please check and try again.';
      } else if (e.toString().contains('session-expired')) {
        errorMessage = 'OTP expired. Please request a new one.';
      }
      
      throw Exception(errorMessage);
    }
  }

  Future<UserCredential> _signInWithCredential(PhoneAuthCredential credential) async {
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    
    if (userCredential.user != null) {
      // Create or update user model
      _currentUser = UserModel(
        id: userCredential.user!.uid,
        phoneNumber: userCredential.user!.phoneNumber ?? '',
        name: userCredential.user!.displayName,
        email: userCredential.user!.email,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save user data locally
      await _saveUserData(_currentUser!.toJson());
    }

    return userCredential;
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? address,
  }) async {
    if (_currentUser == null) throw Exception('User not logged in');

    try {
      // Update Firebase user profile
      if (name != null) {
        await _firebaseAuth.currentUser?.updateDisplayName(name);
      }

      // Update local user model
      _currentUser = _currentUser!.copyWith(
        name: name ?? _currentUser!.name,
        email: email ?? _currentUser!.email,
        address: address ?? _currentUser!.address,
        updatedAt: DateTime.now(),
      );

      await _saveUserData(_currentUser!.toJson());
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<void> loadSavedAuth() async {
    try {
      // Check if user is already signed in with Firebase
      final firebaseUser = _firebaseAuth.currentUser;
      
      if (firebaseUser != null) {
        // Load saved user data
        final prefs = await SharedPreferences.getInstance();
        final userDataString = prefs.getString(AppConstants.userKey);

        if (userDataString != null) {
          final userData = jsonDecode(userDataString);
          _currentUser = UserModel.fromJson(userData);
        } else {
          // Create user model from Firebase user
          _currentUser = UserModel(
            id: firebaseUser.uid,
            phoneNumber: firebaseUser.phoneNumber ?? '',
            name: firebaseUser.displayName,
            email: firebaseUser.email,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          await _saveUserData(_currentUser!.toJson());
        }
      }
    } catch (e) {
      // Handle error silently, user will need to login again
      await logout();
    }
  }

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.userKey);
      await prefs.remove(AppConstants.cartKey);
      
      _currentUser = null;
      _verificationId = null;
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.userKey, jsonEncode(userData));
  }
}