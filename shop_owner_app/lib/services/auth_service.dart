import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/shop_owner_model.dart';
import 'api_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ApiService _apiService = ApiService();
  ShopOwnerModel? _currentOwner;

  ShopOwnerModel? get currentOwner => _currentOwner;
  bool get isLoggedIn => _currentOwner != null;

  Future<void> sendOTP(String phoneNumber) async {
    try {
      await _apiService.post('/auth/shop-owner/send-otp', {
        'phoneNumber': phoneNumber,
      });
    } catch (e) {
      throw Exception('Failed to send OTP: $e');
    }
  }

  Future<ShopOwnerModel> verifyOTP(String phoneNumber, String otp) async {
    try {
      final response = await _apiService.post('/auth/shop-owner/verify-otp', {
        'phoneNumber': phoneNumber,
        'otp': otp,
      });

      final token = response['token'];
      final ownerData = response['shopOwner'];

      await _saveAuthData(token, ownerData);
      
      _currentOwner = ShopOwnerModel.fromJson(ownerData);
      _apiService.setAuthToken(token);

      return _currentOwner!;
    } catch (e) {
      throw Exception('Failed to verify OTP: $e');
    }
  }

  Future<ShopOwnerModel?> loadSavedAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('shop_owner_token');
      final ownerDataString = prefs.getString('shop_owner_data');

      if (token != null && ownerDataString != null) {
        final ownerData = jsonDecode(ownerDataString);
        _currentOwner = ShopOwnerModel.fromJson(ownerData);
        _apiService.setAuthToken(token);
        return _currentOwner;
      }
      return null;
    } catch (e) {
      await logout();
      return null;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('shop_owner_token');
      await prefs.remove('shop_owner_data');
      
      _currentOwner = null;
      _apiService.clearAuthToken();
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  Future<void> _saveAuthData(String token, Map<String, dynamic> ownerData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('shop_owner_token', token);
    await prefs.setString('shop_owner_data', jsonEncode(ownerData));
  }
}