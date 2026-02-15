import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  static const String baseUrl = AppConstants.baseUrl;
  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';
  static const String _userPhoneKey = 'user_phone';

  String? _cachedUserId;
  String? _cachedUserName;

  /// Get or create user (call this on app start)
  Future<String> initializeUser() async {
    try {
      // Check if userId exists in cache
      if (_cachedUserId != null) {
        print('✅ Using cached userId: $_cachedUserId');
        return _cachedUserId!;
      }

      // Check if userId exists in local storage
      final prefs = await SharedPreferences.getInstance();
      final savedUserId = prefs.getString(_userIdKey);

      print('🔍 Checking for saved userId...');

      // Call backend to get or create user
      final response = await http.post(
        Uri.parse('$baseUrl/users/init'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': savedUserId,
        }),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout. Please check your internet connection.');
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final userId = data['data']['userId'];
          final userName = data['data']['name'];

          // Save to local storage
          await prefs.setString(_userIdKey, userId);
          await prefs.setString(_userNameKey, userName);

          // Cache in memory
          _cachedUserId = userId;
          _cachedUserName = userName;

          print('✅ User initialized: $userId');
          return userId;
        } else {
          throw Exception(data['message'] ?? 'Failed to initialize user');
        }
      } else {
        throw Exception('Failed to initialize user');
      }
    } catch (e) {
      print('❌ Error initializing user: $e');
      rethrow;
    }
  }

  /// Get current user ID (from cache or storage)
  Future<String?> getUserId() async {
    if (_cachedUserId != null) {
      return _cachedUserId;
    }

    final prefs = await SharedPreferences.getInstance();
    _cachedUserId = prefs.getString(_userIdKey);
    return _cachedUserId;
  }

  /// Get current user name
  Future<String?> getUserName() async {
    if (_cachedUserName != null) {
      return _cachedUserName;
    }

    final prefs = await SharedPreferences.getInstance();
    _cachedUserName = prefs.getString(_userNameKey);
    return _cachedUserName;
  }

  /// Update user profile
  Future<void> updateProfile({
    String? name,
    String? phone,
    String? email,
  }) async {
    try {
      final userId = await getUserId();
      if (userId == null) {
        throw Exception('User not initialized');
      }

      print('📝 Updating user profile...');

      final response = await http.put(
        Uri.parse('$baseUrl/users/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          if (name != null) 'name': name,
          if (phone != null) 'phone': phone,
          if (email != null) 'email': email,
        }),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout. Please try again.');
        },
      );

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          // Update local storage
          final prefs = await SharedPreferences.getInstance();
          if (name != null) {
            await prefs.setString(_userNameKey, name);
            _cachedUserName = name;
          }
          if (phone != null) {
            await prefs.setString(_userPhoneKey, phone);
          }

          print('✅ Profile updated successfully');
        } else {
          throw Exception(data['message'] ?? 'Failed to update profile');
        }
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      print('❌ Error updating profile: $e');
      rethrow;
    }
  }

  /// Get user details from backend
  Future<Map<String, dynamic>> getUserDetails() async {
    try {
      final userId = await getUserId();
      if (userId == null) {
        throw Exception('User not initialized');
      }

      print('📋 Fetching user details...');

      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId'),
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
    final userId = await getUserId();
    return userId != null && userId.isNotEmpty;
  }

  /// Clear user data (logout)
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userPhoneKey);
    _cachedUserId = null;
    _cachedUserName = null;
    print('🗑️ User data cleared');
  }

  /// Save user name locally (for quick access)
  Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
    _cachedUserName = name;
  }

  /// Get user phone
  Future<String?> getUserPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userPhoneKey);
  }

  /// Save user phone locally
  Future<void> saveUserPhone(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userPhoneKey, phone);
  }
}
