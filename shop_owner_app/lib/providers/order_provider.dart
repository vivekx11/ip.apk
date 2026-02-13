import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/firebase_service.dart';

class OrderProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  
  bool _isLoading = false;
  String? _error;
  List<OrderModel> _orders = [];
  List<OrderModel> _pendingOrders = [];
  List<OrderModel> _acceptedOrders = [];
  List<OrderModel> _completedOrders = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<OrderModel> get orders => _orders;
  List<OrderModel> get pendingOrders => _pendingOrders;
  List<OrderModel> get acceptedOrders => _acceptedOrders;
  List<OrderModel> get completedOrders => _completedOrders;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<void> loadShopOrders(String shopId) async {
    setLoading(true);
    setError(null);

    try {
      _orders = await _firebaseService.getShopOrders(shopId);
      
      _pendingOrders = _orders.where((order) => order.status == 'pending').toList();
      _acceptedOrders = _orders.where((order) => 
        order.status == 'accepted' || order.status == 'ready').toList();
      _completedOrders = _orders.where((order) => order.status == 'completed').toList();
      
    } catch (e) {
      setError(e.toString());
      _orders = [];
      _pendingOrders = [];
      _acceptedOrders = [];
      _completedOrders = [];
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _firebaseService.updateOrderStatus(orderId, status);
      if (_orders.isNotEmpty) {
        final shopId = _orders.first.shopId;
        await loadShopOrders(shopId);
      }
    } catch (e) {
      setError(e.toString());
      rethrow;
    }
  }

  Future<OrderModel?> verifyPickupCode(String pickupCode) async {
    try {
      return await _firebaseService.verifyPickupCode(pickupCode);
    } catch (e) {
      setError(e.toString());
      return null;
    }
  }

  Future<OrderModel?> fetchOrderById(String orderId) async {
    setLoading(true);
    setError(null);
    try {
      return await _firebaseService.getOrderById(orderId);
    } catch (e) {
      setError(e.toString());
      return null;
    } finally {
      setLoading(false);
    }
  }

  Future<void> completeOrder(String orderId) async {
    try {
      await _firebaseService.completeOrder(orderId);
      if (_orders.isNotEmpty) {
        final shopId = _orders.first.shopId;
        await loadShopOrders(shopId);
      }
    } catch (e) {
      setError(e.toString());
      rethrow;
    }
  }
}