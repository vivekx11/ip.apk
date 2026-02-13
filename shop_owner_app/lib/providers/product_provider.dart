import 'package:flutter/material.dart';
import '../services/product_api_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductApiService _productService = ProductApiService();
  
  bool _isLoading = false;
  String? _error;
  List<Map<String, dynamic>> _products = [];
  Map<String, dynamic>? _selectedProduct;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Map<String, dynamic>> get products => _products;
  Map<String, dynamic>? get selectedProduct => _selectedProduct;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Load products for a shop
  Future<void> loadShopProducts(String shopId) async {
    setLoading(true);
    setError(null);

    try {
      final response = await _productService.getProducts(shopId: shopId);
      if (response['success'] == true) {
        _products = List<Map<String, dynamic>>.from(response['data'] ?? []);
      } else {
        _products = [];
      }
    } catch (e) {
      setError(e.toString());
      _products = [];
    } finally {
      setLoading(false);
    }
  }

  // Load single product
  Future<void> loadProduct(String productId) async {
    try {
      final response = await _productService.getProduct(productId);
      if (response['success'] == true) {
        _selectedProduct = response['data'];
        notifyListeners();
      }
    } catch (e) {
      setError(e.toString());
    }
  }

  // Update product
  Future<bool> updateProduct(String productId, Map<String, dynamic> updates) async {
    try {
      final response = await _productService.updateProduct(productId, updates);
      if (response['success'] == true) {
        // Update local list
        final index = _products.indexWhere((p) => p['_id'] == productId);
        if (index != -1) {
          _products[index] = {..._products[index], ...updates};
          notifyListeners();
        }
        return true;
      }
      return false;
    } catch (e) {
      setError(e.toString());
      return false;
    }
  }

  // Delete product
  Future<bool> deleteProduct(String productId) async {
    try {
      final success = await _productService.deleteProduct(productId);
      if (success) {
        _products.removeWhere((p) => p['_id'] == productId);
        notifyListeners();
      }
      return success;
    } catch (e) {
      setError(e.toString());
      return false;
    }
  }

  // Toggle product availability
  Future<bool> toggleAvailability(String productId) async {
    try {
      final response = await _productService.toggleProductAvailability(productId);
      if (response['success'] == true) {
        final index = _products.indexWhere((p) => p['_id'] == productId);
        if (index != -1) {
          _products[index]['isAvailable'] = response['data']['isAvailable'];
          notifyListeners();
        }
        return true;
      }
      return false;
    } catch (e) {
      setError(e.toString());
      return false;
    }
  }

  // Clear products
  void clearProducts() {
    _products = [];
    _selectedProduct = null;
    notifyListeners();
  }
}
