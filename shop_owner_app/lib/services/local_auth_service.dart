// Local Auth service - Simple local authentication without backend calls
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/shop_owner_model.dart';

class LocalAuthService {
  static final LocalAuthService _instance = LocalAuthService._internal();
  factory LocalAuthService() => _instance;
  LocalAuthService._internal();

  static const String _ownerKey = 'local_owner_data';
  static const String _shopIdKey = 'local_shop_id';
  static const String _isProfileSetupKey = 'is_profile_setup';
  
  ShopOwnerModel? _currentOwner;
  String? _shopId;
  bool _isProfileSetup = false;

  ShopOwnerModel? get currentOwner => _currentOwner;
  bool get isLoggedIn => _currentOwner != null;
  String? get shopId => _shopId;
  bool get isProfileSetup => _isProfileSetup;

  /// Simple login - just creates a local user ID
  Future<String> simpleLogin() async {
    // Generate unique owner ID
    final ownerId = 'owner_${DateTime.now().millisecondsSinceEpoch}';
    
    // Save login status
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('temp_owner_id', ownerId);
    
    print('✅ Simple login successful: $ownerId');
    return ownerId;
  }

  /// Setup profile after login - saves name and shop name locally
  Future<void> setupProfile(String ownerName, String shopName) async {
    final prefs = await SharedPreferences.getInstance();
    final ownerId = prefs.getString('temp_owner_id') ?? 
                    'owner_${DateTime.now().millisecondsSinceEpoch}';
    
    // Create shop owner model
    _currentOwner = ShopOwnerModel(
      id: ownerId,
      phoneNumber: ownerId,
      name: ownerName.trim(),
      shopName: shopName.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Generate local shop ID
    _shopId = 'shop_${DateTime.now().millisecondsSinceEpoch}';
    _isProfileSetup = true;

    // Save to local storage
    await _saveOwnerData();
    await prefs.remove('temp_owner_id');
    
    print('✅ Profile setup complete');
    print('👤 Owner: $ownerName');
    print('🏪 Shop: $shopName');
    print('🆔 Shop ID: $_shopId');
  }

  /// Load saved owner data
  Future<Map<String, dynamic>?> loadSavedAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ownerDataString = prefs.getString(_ownerKey);
      final savedShopId = prefs.getString(_shopIdKey);
      final profileSetup = prefs.getBool(_isProfileSetupKey) ?? false;

      if (ownerDataString != null && savedShopId != null && profileSetup) {
        final ownerData = jsonDecode(ownerDataString);
        _currentOwner = ShopOwnerModel.fromJson(ownerData);
        _shopId = savedShopId;
        _isProfileSetup = profileSetup;
        
        print('✅ Loaded saved auth');
        print('👤 Owner: ${_currentOwner!.name}');
        print('🏪 Shop: ${_currentOwner!.shopName}');
        
        return {
          'owner': _currentOwner,
          'shopId': _shopId,
        };
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
      await prefs.remove(_isProfileSetupKey);
      await prefs.remove('temp_owner_id');
      _currentOwner = null;
      _shopId = null;
      _isProfileSetup = false;
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
    await prefs.setBool(_isProfileSetupKey, _isProfileSetup);
  }
}
