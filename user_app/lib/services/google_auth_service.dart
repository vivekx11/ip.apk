import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../models/user_model.dart';

class GoogleAuthService {
  static final GoogleAuthService _instance = GoogleAuthService._internal();
  factory GoogleAuthService() => _instance;
  GoogleAuthService._internal();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  UserModel? _currentUser;
  GoogleSignInAccount? _googleAccount;

  UserModel? get currentUser => _currentUser;
  GoogleSignInAccount? get googleAccount => _googleAccount;
  bool get isLoggedIn => _currentUser != null;

  /// Sign in with Google
  Future<UserModel> signInWithGoogle() async {
    try {
      print('🔐 Starting Google Sign-In...');
      
      // Trigger Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        throw Exception('Google Sign-In cancelled');
      }

      _googleAccount = googleUser;
      
      print('✅ Google Sign-In successful');
      print('Name: ${googleUser.displayName}');
      print('Email: ${googleUser.email}');
      print('ID: ${googleUser.id}');

      // Call backend to create/get user
      final user = await _registerUserWithBackend(
        userId: googleUser.id,
        name: googleUser.displayName ?? 'User',
        email: googleUser.email,
      );

      _currentUser = user;
      await _saveUserLocally(user);

      return user;
    } catch (e) {
      print('❌ Google Sign-In error: $e');
      rethrow;
    }
  }

  /// Register/Login user with backend
  Future<UserModel> _registerUserWithBackend({
    required String userId,
    required String name,
    required String email,
  }) async {
    try {
      print('📡 Calling backend API...');
      
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/users'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'name': name,
          'email': email,
        }),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout. Please check your internet connection.');
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          print('✅ User registered/logged in successfully');
          return UserModel.fromJson(data['data']);
        } else {
          throw Exception(data['message'] ?? 'Failed to register user');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to register user');
      }
    } catch (e) {
      print('❌ Backend API error: $e');
      rethrow;
    }
  }

  /// Save user data locally
  Future<void> _saveUserLocally(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', json.encode(user.toJson()));
      await prefs.setString('auth_method', 'google');
      print('💾 User data saved locally');
    } catch (e) {
      print('⚠️ Error saving user locally: $e');
    }
  }

  /// Load saved user
  Future<UserModel?> loadSavedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      final authMethod = prefs.getString('auth_method');

      if (userData != null && authMethod == 'google') {
        _currentUser = UserModel.fromJson(json.decode(userData));
        print('✅ Loaded saved user: ${_currentUser!.name}');
        
        // Try to sign in silently
        _googleAccount = await _googleSignIn.signInSilently();
        
        return _currentUser;
      }
    } catch (e) {
      print('⚠️ Error loading saved user: $e');
    }
    return null;
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_data');
      await prefs.remove('auth_method');
      _currentUser = null;
      _googleAccount = null;
      print('✅ User signed out');
    } catch (e) {
      print('❌ Error signing out: $e');
      rethrow;
    }
  }

  /// Update user profile
  Future<void> updateProfile({String? name, String? address}) async {
    if (_currentUser != null) {
      _currentUser = UserModel(
        id: _currentUser!.id,
        phoneNumber: _currentUser!.phoneNumber,
        name: name ?? _currentUser!.name,
        email: _currentUser!.email,
        address: address ?? _currentUser!.address,
        createdAt: _currentUser!.createdAt,
        updatedAt: DateTime.now(),
      );
      await _saveUserLocally(_currentUser!);
    }
  }
}
