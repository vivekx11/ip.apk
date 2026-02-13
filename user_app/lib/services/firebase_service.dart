// Firebase service - DEPRECATED
// This file is kept for backward compatibility but is no longer used.
// All functionality has been migrated to custom backend APIs.

import '../models/order_model.dart';
import '../models/shop_model.dart';
import '../models/product_model.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  // This service is deprecated and no longer functional
  // Use the following services instead:
  // - ProductApiService for product operations
  // - ShopService for shop operations
  // - API services for all backend operations
  
  // Stub methods for compatibility
  Future<List<Shop>> getShops() async {
    return [];
  }
  
  Future<List<Product>> getShopProducts(String shopId) async {
    return [];
  }
  
  Future<Shop?> getShopById(String shopId) async {
    return null;
  }
  
  Future<List<Order>> getUserOrders(String userId) async {
    return [];
  }
  
  Future<String> createOrder(Order order) async {
    return '';
  }
  
  Future<Order?> getOrderById(String orderId) async {
    return null;
  }
}
