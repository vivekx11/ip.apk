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

  Future<void> loadShopOrders(String shopId) async {
    setLoading(true);
    setError(null);

    try {
      final ordersData = await _orderService.getShopOrders(shopId);
      _orders = ordersData.map((data) => OrderModel.fromJson(data)).toList();
      
      _pendingOrders = _orders.where((order) => order.status == 'Pending').toList();
      _acceptedOrders = _orders.where((order) => order.status == 'Accepted').toList();
      _completedOrders = _orders.where((order) => order.status == 'Completed').toList();
      
      print('✅ Loaded ${_orders.length} orders (${_pendingOrders.length} pending, ${_acceptedOrders.length} accepted, ${_completedOrders.length} completed)');
    } catch (e) {
      print('❌ Error loading orders: $e');
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
      await _orderService.updateOrderStatus(orderId, status);
      
      // Reload orders
      if (_orders.isNotEmpty) {
        final shopId = _orders.first.shopId;
        await loadShopOrders(shopId);
      }
    } catch (e) {
      setError(e.toString());
      rethrow;
    }
  }

  Future<void> verifyPinAndComplete(String orderId, String pickupPin) async {
    try {
      await _orderService.verifyPinAndComplete(orderId, pickupPin);
      
      // Reload orders
      if (_orders.isNotEmpty) {
        final shopId = _orders.first.shopId;
        await loadShopOrders(shopId);
      }
    } catch (e) {
      setError(e.toString());
      rethrow;
    }
  }

  Future<OrderModel?> fetchOrderById(String orderId) async {
    setLoading(true);
    setError(null);
    try {
      final orderData = await _orderService.getOrderById(orderId);
      return OrderModel.fromJson(orderData);
    } catch (e) {
      setError(e.toString());
      return null;
    } finally {
      setLoading(false);
    }
  }
}