// Firebase service - DEPRECATED
// This file is kept for backward compatibility but is no longer used.
// All functionality has been migrated to custom backend APIs.

import '../models/order_model.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  // This service is deprecated and no longer functional
  // Use the following services instead:
  // - ProductApiService for product operations
  // - CloudinaryUploadService for image uploads
  // - OrderService for order operations
  
  // Stub methods for compatibility
  Future<Map<String, dynamic>?> getShopByOwnerId(String ownerId) async {
    return null;
  }
  
  Future<List<Map<String, dynamic>>> getShopProducts(String shopId) async {
    return [];
  }
  
  Future<String> createShop(Map<String, dynamic> shopData) async {
    return '';
  }
  
  Future<void> updateShop(String shopId, Map<String, dynamic> updates) async {
    // Stub
  }
  
  Future<String> createProduct(Map<String, dynamic> productData) async {
    return '';
  }
  
  Future<void> updateProduct(String productId, Map<String, dynamic> updates) async {
    // Stub
  }
  
  Future<void> deleteProduct(String productId) async {
    // Stub
  }
  
  Future<List<OrderModel>> getShopOrders(String shopId) async {
    return [];
  }
  
  Future<void> updateOrderStatus(String orderId, String status) async {
    // Stub
  }
  
  Future<OrderModel?> verifyPickupCode(String pickupCode) async {
    return null;
  }
  
  Future<OrderModel?> getOrderById(String orderId) async {
    return null;
  }
  
  Future<void> completeOrder(String orderId) async {
    // Stub
  }
}
