import 'package:flutter/material.dart';
import '../models/shop_model.dart';
import '../models/product_model.dart';
import '../services/firebase_service.dart';

class ShopProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  
  bool _isLoading = false;
  String? _error;
  List<Shop> _shops = [];
  Map<String, List<Product>> _shopProducts = {};

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Shop> get shops => _shops;
  
  List<Product> getShopProducts(String shopId) {
    return _shopProducts[shopId] ?? [];
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<void> loadShops() async {
    setLoading(true);
    setError(null);

    try {
      _shops = await _firebaseService.getShops();
    } catch (e) {
      setError(e.toString());
      _shops = [];
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadShopProducts(String shopId) async {
    try {
      final products = await _firebaseService.getShopProducts(shopId);
      _shopProducts[shopId] = products;
      notifyListeners();
    } catch (e) {
      setError(e.toString());
      _shopProducts[shopId] = [];
    }
  }

  Future<Shop?> getShopById(String shopId) async {
    try {
      return await _firebaseService.getShopById(shopId);
    } catch (e) {
      setError(e.toString());
      return null;
    }
  }
}