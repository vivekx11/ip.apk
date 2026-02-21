import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../models/user_model.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  static const String baseUrl = AppConstants.baseUrl;
  static const String _userDataKey = 'user_data';

  UserModel? _cachedUser;

  /// Create or get user from backend
  Future<UserModel> createOrGetUser({
    required String phoneNumber,
    required String name,
  }) async {
    try {
      print('📡 Creating/getting user...');
      
      final response = await http.post(
        Uri.parse('$baseUrl/users'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': phoneNumber,
          'name': name,
          'phoneNumber': phoneNumber,
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
          final user = UserModel.fromJson(data['data']);
          await _saveUser(user);
          _cachedUser = user;
          print('✅ User created/retrieved successfully');
          return user;
        } else {
          throw Exception(data['message'] ?? 'Failed to create user');
        }
      } else {
        throw Exception('Failed to create user');
      }
    } catch (e) {
      print('❌ Error creating user: $e');
      rethrow;
    }
  }

  /// Load saved user from local storage
  Future<UserModel?> loadSavedUser() async {
    try {
      if (_cachedUser != null) {
        return _cachedUser;
      }

      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(_userDataKey);
      
      if (userData != null) {
        _cachedUser = UserModel.fromJson(json.decode(userData));
        print('✅ Loaded saved user: ${_cachedUser!.name}');
        return _cachedUser;
      }
    } catch (e) {
      print('⚠️ Error loading saved user: $e');
    }
    return null;
  }

  /// Save user to local storage
  Future<void> _saveUser(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userDataKey, json.encode(user.toJson()));
      print('💾 User data saved locally');
    } catch (e) {
      print('⚠️ Error saving user: $e');
    }
  }

  /// Get current user
  UserModel? get currentUser => _cachedUser;

  /// Update user profile
  Future<void> updateProfile({
    String? name,
    String? email,
    String? address,
  }) async {
    if (_cachedUser != null) {
      _cachedUser = UserModel(
        id: _cachedUser!.id,
        phoneNumber: _cachedUser!.phoneNumber,
        name: name ?? _cachedUser!.name,
        email: email ?? _cachedUser!.email,
        address: address ?? _cachedUser!.address,
        createdAt: _cachedUser!.createdAt,
        updatedAt: DateTime.now(),
      );
      await _saveUser(_cachedUser!);
    }
  }

  /// Clear user data (logout)
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userDataKey);
    _cachedUser = null;
    print('🗑️ User data cleared');
  }

  /// Get user details from backend
  Future<Map<String, dynamic>> getUserDetails() async {
    try {
      if (_cachedUser == null) {
        throw Exception('User not initialized');
      }

      print('📋 Fetching user details...');

      final response = await http.get(
        Uri.parse('$baseUrl/users/${_cachedUser!.id}'),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout. Please try again.');
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return data['data'];
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch user details');
        }
      } else {
        throw Exception('Failed to fetch user details');
      }
    } catch (e) {
      print('❌ Error fetching user details: $e');
      rethrow;
    }
  }

  /// Check if user is initialized
  Future<bool> isUserInitialized() async {
    final user = await loadSavedUser();
    return user != null;
  }
}
