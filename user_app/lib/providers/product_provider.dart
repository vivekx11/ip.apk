import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();
  
  bool _isLoading = false;
  String? _error;
  List<Product> _products = [];
  Map<String, List<Product>> _shopProducts = {};

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Product> get products => _products;
  
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

  // Load all products
  Future<void> loadProducts() async {
    setLoading(true);
    setError(null);

    try {
      _products = await _productService.getAllProducts();
    } catch (e) {
      setError(e.toString());
      _products = [];
    } finally {
      setLoading(false);
    }
  }

  // Load products for a specific shop
  Future<void> loadShopProducts(String shopId) async {
    try {
      final products = await _productService.getProductsByShop(shopId);
      _shopProducts[shopId] = products;
      notifyListeners();
    } catch (e) {
      setError(e.toString());
      _shopProducts[shopId] = [];
    }
  }

  // Get unique shop names from products
  List<String> getUniqueShopNames() {
    final shopNames = _products.map((p) => p.shopName).toSet().toList();
    shopNames.sort();
    return shopNames;
  }
}
