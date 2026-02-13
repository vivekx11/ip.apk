import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/shop_owner_model.dart';
import 'shop_api_service.dart';

/// Simple username-based authentication service for shop owners (No OTP required)
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

  /// Login with just username (no password/OTP) + Auto-create shop
  Future<ShopOwnerModel> loginWithUsername(String username, String shopName) async {
    if (username.trim().isEmpty) {
      throw Exception('Please enter a username');
    }
    if (shopName.trim().isEmpty) {
      throw Exception('Please enter a shop name');
    }

    // Generate unique owner ID using phone number format
    final ownerId = DateTime.now().millisecondsSinceEpoch.toString();

    // Create shop owner model
    _currentOwner = ShopOwnerModel(
      id: ownerId,
      phoneNumber: ownerId,
      name: username.trim(),
      shopName: shopName.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Auto-create shop in backend - CRITICAL STEP
    try {
      print('🏪 Creating shop for owner: $ownerId');
      final shopData = {
        'name': shopName.trim(),
        'description': 'Welcome to ${shopName.trim()}',
        'category': 'Other', // Use 'Other' instead of 'General'
        'address': 'Local Area',
        'phone': ownerId,
        'ownerName': username.trim(),
        'ownerId': ownerId,
      };

      final shop = await _shopApiService.createShop(shopData);
      _shopId = shop['_id'] ?? shop['id'];
      
      if (_shopId == null || _shopId!.isEmpty) {
        throw Exception('Shop created but no ID received');
      }
      
      print('✅ Shop created successfully with ID: $_shopId');
    } catch (e) {
      print('⚠️ Shop creation error: $e');
      
      // If shop already exists, try to fetch it
      try {
        final existingShop = await _shopApiService.getShopByOwnerId(ownerId);
        if (existingShop != null) {
          _shopId = existingShop['_id'] ?? existingShop['id'];
          print('✅ Found existing shop with ID: $_shopId');
        } else {
          throw Exception('Could not create or find shop');
        }
      } catch (fetchError) {
        print('❌ Could not fetch existing shop: $fetchError');
        throw Exception('Failed to setup shop. Please try again.');
      }
    }

    // Verify shopId is saved
    if (_shopId == null || _shopId!.isEmpty) {
      throw Exception('Shop setup failed. Please try again.');
    }

    // Save to local storage
    await _saveOwnerData();
    print('💾 Owner and shopId saved: $_shopId');
    
    return _currentOwner!;
  }

  /// Load saved owner data
  Future<ShopOwnerModel?> loadSavedAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ownerDataString = prefs.getString(_ownerKey);
      final savedShopId = prefs.getString(_shopIdKey);

      if (ownerDataString != null) {
        final ownerData = jsonDecode(ownerDataString);
        _currentOwner = ShopOwnerModel.fromJson(ownerData);
        _shopId = savedShopId;
        
        // If shopId not saved, try to fetch from backend
        if (_shopId == null && _currentOwner != null) {
          try {
            final shop = await _shopApiService.getShopByOwnerId(_currentOwner!.id);
            if (shop != null) {
              _shopId = shop['_id'] ?? shop['id'];
              await prefs.setString(_shopIdKey, _shopId!);
              print('✅ Fetched and saved shopId: $_shopId');
            }
          } catch (e) {
            print('⚠️ Could not fetch shopId: $e');
          }
        }
        
        return _currentOwner;
      }
      return null;
    } catch (e) {
      print('Error loading saved auth: $e');
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
  }
}
