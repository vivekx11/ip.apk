import 'package:flutter/material.dart';
import '../models/order_model.dart' as order_model;
import '../services/firebase_service.dart';

class OrderProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  
  bool _isLoading = false;
  String? _error;
  List<order_model.Order> _orders = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<order_model.Order> get orders => _orders;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<void> loadUserOrders(String userId) async {
    setLoading(true);
    setError(null);

    try {
      _orders = await _firebaseService.getUserOrders(userId);
    } catch (e) {
      setError(e.toString());
      _orders = [];
    } finally {
      setLoading(false);
    }
  }

  Future<String> createOrder(order_model.Order order) async {
    try {
      final orderId = await _firebaseService.createOrder(order);
      // Reload orders after creating new one
      await loadUserOrders(order.userId);
      return orderId;
    } catch (e) {
      setError(e.toString());
      rethrow;
    }
  }

  Future<order_model.Order?> getOrderById(String orderId) async {
    try {
      return await _firebaseService.getOrderById(orderId);
    } catch (e) {
      setError(e.toString());
      return null;
    }
  }
}
