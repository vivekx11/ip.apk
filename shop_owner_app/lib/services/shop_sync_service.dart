import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import 'simple_auth_service.dart';

/// Service to sync local shop data with backend
class ShopSyncService {
  static final ShopSyncService _instance = ShopSyncService._internal();
  factory ShopSyncService() => _instance;
  ShopSyncService._internal();

  static const String baseUrl = AppConstants.baseUrl;
  static const String _backendShopIdKey = 'backend_shop_id';
  static const String _isSyncedKey = 'is_shop_synced';

  String? _backendShopId;
  bool _isSynced = false;

  String? get backendShopId => _backendShopId;
  bool get isSynced => _isSynced;

  /// Sync local shop with backend (call before first product upload)
  Future<String> syncShopWithBackend() async {
    try {
      // Check if already synced
      final prefs = await SharedPreferences.getInstance();
      final savedBackendShopId = prefs.getString(_backendShopIdKey);
      final synced = prefs.getBool(_isSyncedKey) ?? false;

      if (synced && savedBackendShopId != null && savedBackendShopId.isNotEmpty) {
        _backendShopId = savedBackendShopId;
        _isSynced = true;
        print('✅ Shop already synced with backend: $_backendShopId');
        return _backendShopId!;
      }

      // Get local shop data from SimpleAuthService
      final simpleAuthService = SimpleAuthService();
      final owner = simpleAuthService.currentOwner;

      if (owner == null) {
        throw Exception('Owner not logged in');
      }

      print('🔄 Syncing shop with backend...');
      print('Owner ID: ${owner.id}');
      print('Owner Name: ${owner.name}');
      print('Shop Name: ${owner.shopName}');

      // Create shop in backend
      final response = await http.post(
        Uri.parse('$baseUrl/shops'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': owner.shopName,
          'description': 'Welcome to ${owner.shopName}',
          'category': 'Other',
          'address': 'Local Area',
          'phone': owner.phoneNumber, // Use actual phone number with +91
          'ownerName': owner.name,
          'ownerId': owner.id,
          'email': owner.email ?? '',
        }),
      ).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          throw Exception('Request timeout. Please check your internet connection.');
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          _backendShopId = data['data']['_id'] ?? data['data']['id'];
          _isSynced = true;

          // Save backend shop ID
          await prefs.setString(_backendShopIdKey, _backendShopId!);
          await prefs.setBool(_isSyncedKey, true);

          print('✅ Shop synced successfully with backend');
          print('Backend Shop ID: $_backendShopId');

          return _backendShopId!;
        } else {
          throw Exception(data['message'] ?? 'Failed to sync shop');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to sync shop');
      }
    } catch (e) {
      print('❌ Error syncing shop: $e');
      rethrow;
    }
  }

  /// Load saved backend shop ID
  Future<void> loadSavedBackendShopId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _backendShopId = prefs.getString(_backendShopIdKey);
      _isSynced = prefs.getBool(_isSyncedKey) ?? false;

      if (_backendShopId != null) {
        print('✅ Loaded backend shop ID: $_backendShopId');
      }
    } catch (e) {
      print('⚠️ Error loading backend shop ID: $e');
    }
  }

  /// Clear sync data (on logout)
  Future<void> clearSyncData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_backendShopIdKey);
      await prefs.remove(_isSyncedKey);
      _backendShopId = null;
      _isSynced = false;
      print('🗑️ Sync data cleared');
    } catch (e) {
      print('⚠️ Error clearing sync data: $e');
    }
  }

  /// Check if shop needs sync before product operations
  Future<bool> ensureShopSynced() async {
    try {
      if (_isSynced && _backendShopId != null) {
        return true;
      }

      await syncShopWithBackend();
      return true;
    } catch (e) {
      print('❌ Failed to ensure shop sync: $e');
      return false;
    }
  }
}
