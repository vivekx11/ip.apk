import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/shop_owner_model.dart';
import 'shop_sync_service.dart';

class GoogleAuthService {
  static final GoogleAuthService _instance = GoogleAuthService._internal();
  factory GoogleAuthService() => _instance;
  GoogleAuthService._internal();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  ShopOwnerModel? _currentOwner;
  String? _shopId;
  GoogleSignInAccount? _googleAccount;
  bool _isProfileSetup = false;

  ShopOwnerModel? get currentOwner => _currentOwner;
  String? get shopId => _shopId;
  bool get isLoggedIn => _currentOwner != null;
  bool get isProfileSetup => _isProfileSetup;
  GoogleSignInAccount? get googleAccount => _googleAccount;

  /// Step 1: Sign in with Google (just authentication)
  Future<GoogleSignInAccount> signInWithGoogle() async {
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

      // Save temp Google account info
      await _saveTempGoogleAccount(googleUser);

      return googleUser;
    } catch (e) {
      print('❌ Google Sign-In error: $e');
      rethrow;
    }
  }

  /// Step 2: Setup profile after Google Sign-In
  Future<Map<String, dynamic>> setupProfile({
    required String ownerName,
    required String shopName,
    required String phone,
  }) async {
    try {
      if (_googleAccount == null) {
        // Try to load from temp storage
        final prefs = await SharedPreferences.getInstance();
        final tempData = prefs.getString('temp_google_account');
        if (tempData == null) {
          throw Exception('Google account not found. Please sign in again.');
        }
        final data = json.decode(tempData);
        // Try to sign in silently
        _googleAccount = await _googleSignIn.signInSilently();
        if (_googleAccount == null) {
          throw Exception('Google session expired. Please sign in again.');
        }
      }

      final googleUser = _googleAccount!;

      // Create shop owner model with provided details
      _currentOwner = ShopOwnerModel(
        id: googleUser.id,
        phoneNumber: '+91$phone', // Add +91 prefix
        name: ownerName.trim(),
        email: googleUser.email,
        shopName: shopName.trim(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Generate local shop ID
      _shopId = 'shop_${DateTime.now().millisecondsSinceEpoch}';
      _isProfileSetup = true;

      // Save locally
      await _saveOwnerLocally();
      
      // Clear temp data
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('temp_google_account');

      print('✅ Profile setup complete');
      print('👤 Owner: $ownerName');
      print('🏪 Shop: $shopName');
      print('📱 Phone: +91$phone');
      print('🆔 Shop ID: $_shopId');

      return {
        'owner': _currentOwner,
        'shopId': _shopId,
      };
    } catch (e) {
      print('❌ Profile setup error: $e');
      rethrow;
    }
  }

  /// Save temp Google account info
  Future<void> _saveTempGoogleAccount(GoogleSignInAccount account) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('temp_google_account', json.encode({
        'id': account.id,
        'email': account.email,
        'displayName': account.displayName,
      }));
      print('💾 Temp Google account saved');
    } catch (e) {
      print('⚠️ Error saving temp Google account: $e');
    }
  }

  /// Save owner data locally
  Future<void> _saveOwnerLocally() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_currentOwner != null) {
        await prefs.setString('owner_data', json.encode(_currentOwner!.toJson()));
      }
      if (_shopId != null) {
        await prefs.setString('shop_id', _shopId!);
      }
      await prefs.setBool('is_profile_setup', _isProfileSetup);
      await prefs.setString('auth_method', 'google');
      print('💾 Owner and shop data saved locally');
    } catch (e) {
      print('⚠️ Error saving data locally: $e');
    }
  }

  /// Load saved owner
  Future<Map<String, dynamic>?> loadSavedOwner() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ownerData = prefs.getString('owner_data');
      final savedShopId = prefs.getString('shop_id');
      final profileSetup = prefs.getBool('is_profile_setup') ?? false;
      final authMethod = prefs.getString('auth_method');

      if (ownerData != null && savedShopId != null && profileSetup && authMethod == 'google') {
        _currentOwner = ShopOwnerModel.fromJson(json.decode(ownerData));
        _shopId = savedShopId;
        _isProfileSetup = profileSetup;
        print('✅ Loaded saved owner: ${_currentOwner!.name}');
        
        // Try to sign in silently
        _googleAccount = await _googleSignIn.signInSilently();
        
        return {
          'owner': _currentOwner,
          'shopId': _shopId,
        };
      }
    } catch (e) {
      print('⚠️ Error loading saved owner: $e');
    }
    return null;
  }

  /// Check if temp Google account exists (for profile setup screen)
  Future<bool> hasTempGoogleAccount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey('temp_google_account');
    } catch (e) {
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('owner_data');
      await prefs.remove('shop_id');
      await prefs.remove('is_profile_setup');
      await prefs.remove('auth_method');
      await prefs.remove('temp_google_account');
      
      // Clear sync data
      final shopSyncService = ShopSyncService();
      await shopSyncService.clearSyncData();
      
      _currentOwner = null;
      _googleAccount = null;
      _shopId = null;
      _isProfileSetup = false;
      print('✅ Owner signed out');
    } catch (e) {
      print('❌ Error signing out: $e');
      rethrow;
    }
  }

  /// Update owner profile
  Future<void> updateProfile({String? name, String? shopName}) async {
    if (_currentOwner != null) {
      _currentOwner = _currentOwner!.copyWith(
        name: name ?? _currentOwner!.name,
        shopName: shopName ?? _currentOwner!.shopName,
        updatedAt: DateTime.now(),
      );
      await _saveOwnerLocally();
    }
  }
}
