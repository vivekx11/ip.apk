import 'package:flutter/material.dart';
import '../services/shop_api_service.dart';

class ShopProvider extends ChangeNotifier {
  final ShopApiService _shopApiService = ShopApiService();
  
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _currentShop;
  String? _shopId;

  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get currentShop => _currentShop;
  String? get shopId => _shopId;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void setShopId(String? shopId) {
    _shopId = shopId;
    notifyListeners();
  }

  Future<void> loadShopByOwnerId(String ownerId) async {
    setLoading(true);
    setError(null);

    try {
      _currentShop = await _shopApiService.getShopByOwnerId(ownerId);
    } catch (e) {
      print('Error loading shop: $e');
      setError(e.toString());
      _currentShop = null;
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadShop(String shopId) async {
    setLoading(true);
    setError(null);

    try {
      _currentShop = await _shopApiService.getShop(shopId);
    } catch (e) {
      print('Error loading shop: $e');
      setError(e.toString());
      _currentShop = null;
    } finally {
      setLoading(false);
    }
  }

  Future<void> createShop(Map<String, dynamic> shopData) async {
    setLoading(true);
    setError(null);

    try {
      _currentShop = await _shopApiService.createShop(shopData);
    } catch (e) {
      print('Error creating shop: $e');
      setError(e.toString());
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateShop(String shopId, Map<String, dynamic> updates) async {
    setLoading(true);
    setError(null);

    try {
      final updatedShop = await _shopApiService.updateShop(shopId, updates);
      _currentShop = updatedShop;
      notifyListeners();
    } catch (e) {
      print('Error updating shop: $e');
      setError(e.toString());
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  Future<void> toggleShopStatus() async {
    if (_currentShop == null) return;

    try {
      final shopId = _currentShop!['_id'] ?? _currentShop!['id'];
      final updatedShop = await _shopApiService.toggleShopStatus(shopId);
      _currentShop = updatedShop;
      notifyListeners();
    } catch (e) {
      print('Error toggling shop status: $e');
      setError(e.toString());
      rethrow;
    }
  }

  void clearShop() {
    _currentShop = null;
    _shopId = null;
    _error = null;
    notifyListeners();
  }
}