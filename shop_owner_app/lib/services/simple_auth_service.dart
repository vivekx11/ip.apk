import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/shop_owner_model.dart';
import 'shop_api_service.dart';

/// Simple authentication service with Google Sign-In support
class SimpleAuthService {
  static final SimpleAuthService _instance = SimpleAuthService._internal();
  factory SimpleAuthService() => _instance;
  SimpleAuthService._internal();

  static const String _ownerKey = 'simple_owner_data';
  static const String _shopIdKey = 'shop_id';
  ShopOwnerModel? _currentOwner;
  String? _shopId;
  final ShopApiService _shopApiService = ShopApiService();

  ShopOwnerModel? get currentOwner => _currentOwner;
  bool get isLoggedIn => _currentOwner != null;
  String? get shopId => _shopId;

  /// Check if user already has a shop (for existing users)
  Future<Map<String, dynamic>?> checkExistingShop(String googleUserId) async {
    try {
      print('🔍 Checking existing shop for Google user: $googleUserId');
      final shop = await _shopApiService.getShopByOwnerId(googleUserId);
      
      if (shop != null) {
        // Shop exists - load owner data
        _shopId = shop['_id'] ?? shop['id'];
        _currentOwner = ShopOwnerModel(
          id: googleUserId,
          phoneNumber: shop['phone'] ?? googleUserId,
          name: shop['ownerName'] ?? 'Owner',
          shopName: shop['name'] ?? 'My Shop',
          email: shop['email'] ?? '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        await _saveOwnerData();
        
        print('✅ Existing shop found: $_shopId');
        return {
          'owner': _currentOwner,
          'shopId': _shopId,
        };
      }
      
      print('ℹ️  No existing shop found');
      return null;
    } catch (e) {
      print('⚠️ Error checking existing shop: $e');
      return null;
    }
  }

  /// Login with Google and create shop
  Future<Map<String, dynamic>> loginWithGoogle({
    required GoogleSignInAccount googleUser,
    required String ownerName,
    required String shopName,
    required String phone,
  }) async {
    try {
      print('🔐 Google login with shop creation');
      print('Google ID: ${googleUser.id}');
      print('Email: ${googleUser.email}');
      
      // Create shop owner model
      _currentOwner = ShopOwnerModel(
        id: googleUser.id,
        phoneNumber: phone,
        name: ownerName.trim(),
        shopName: shopName.trim(),
        email: googleUser.email,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Create shop in backend
      print('🏪 Creating shop in backend...');
      final shopData = {
        'name': shopName.trim(),
        'description': 'Welcome to ${shopName.trim()}',
        'category': 'Other',
        'address': 'Local Area',
        'phone': phone,
        'ownerName': ownerName.trim(),
        'ownerId': googleUser.id,
        'email': googleUser.email,
      };

      final shop = await _shopApiService.createShop(shopData);
      _shopId = shop['_id'] ?? shop['id'];
      
      if (_shopId == null || _shopId!.isEmpty) {
        throw Exception('Shop created but no ID received');
      }
      
      print('✅ Shop created successfully with ID: $_shopId');

      // Save to local storage
      await _saveOwnerData();
      print('💾 Owner and shopId saved');
      
      return {
        'owner': _currentOwner,
        'shopId': _shopId,
      };
    } catch (e) {
      print('❌ Google login error: $e');
      rethrow;
    }
  }

  /// Load saved owner data
  Future<Map<String, dynamic>?> loadSavedAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ownerDataString = prefs.getString(_ownerKey);
      final savedShopId = prefs.getString(_shopIdKey);

      if (ownerDataString != null && savedShopId != null) {
        final ownerData = jsonDecode(ownerDataString);
        _currentOwner = ShopOwnerModel.fromJson(ownerData);
        _shopId = savedShopId;
        
        print('✅ Loaded saved owner: ${_currentOwner!.name}');
        
        return {
          'owner': _currentOwner,
          'shopId': _shopId,
        };
      }
      return null;
    } catch (e) {
      print('⚠️ Error loading saved auth: $e');
      return null;
    }
  }

  /// Update owner profile
  Future<void> updateProfile({
    String? name,
    String? shopName,
    String? email,
  }) async {
    if (_currentOwner == null) throw Exception('Owner not logged in');

    _currentOwner = _currentOwner!.copyWith(
      name: name ?? _currentOwner!.name,
      shopName: shopName ?? _currentOwner!.shopName,
      email: email ?? _currentOwner!.email,
      updatedAt: DateTime.now(),
    );

    await _saveOwnerData();
  }

  /// Logout
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_ownerKey);
      await prefs.remove(_shopIdKey);
      _currentOwner = null;
      _shopId = null;
      print('✅ Logged out successfully');
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  /// Save owner data to local storage
  Future<void> _saveOwnerData() async {
    if (_currentOwner == null) return;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_ownerKey, jsonEncode(_currentOwner!.toJson()));
    if (_shopId != null) {
      await prefs.setString(_shopIdKey, _shopId!);
    }
    print('💾 Owner and shop data saved');
  }
}
