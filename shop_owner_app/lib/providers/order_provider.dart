import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService _orderService = OrderService();
  
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

  Future<void> loadOrders(String shopId) async {
    setLoading(true);
    setError(null);

    try {
      _orders = await _orderService.getShopOrders(shopId);
      
      // Categorize orders by status
      _pendingOrders = _orders.where((order) => order.status == 'pending').toList();
      _acceptedOrders = _orders.where((order) => order.status == 'preparing' || order.status == 'ready').toList();
      _completedOrders = _orders.where((order) => order.status == 'completed').toList();
      
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _orderService.updateOrderStatus(orderId, status);
      // Reload orders to get updated data
      final shopId = _orders.firstWhere((order) => order.id == orderId).shopId;
      await loadOrders(shopId);
    } catch (e) {
      setError(e.toString());
    }
  }

  Future<OrderModel?> verifyPickupCode(String code) async {
    try {
      return await _orderService.verifyPickupCode(code);
    } catch (e) {
      setError(e.toString());
      return null;
    }
  }

  Future<void> completeOrder(String orderId) async {
    try {
      await _orderService.completeOrder(orderId);
      // Reload orders to get updated data
      final shopId = _orders.firstWhere((order) => order.id == orderId).shopId;
      await loadOrders(shopId);
    } catch (e) {
      setError(e.toString());
    }
  }
}