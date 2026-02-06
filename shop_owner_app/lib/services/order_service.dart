import '../models/order_model.dart';
import 'api_service.dart';

class OrderService {
  static final OrderService _instance = OrderService._internal();
  factory OrderService() => _instance;
  OrderService._internal();

  final ApiService _apiService = ApiService();

  Future<List<OrderModel>> getShopOrders(String shopId, {String? status}) async {
    try {
      String endpoint = '/orders/shop/$shopId';
      if (status != null) {
        endpoint += '?status=$status';
      }
      
      final response = await _apiService.get(endpoint);
      
      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> ordersData = response['data'];
        return ordersData.map((json) => OrderModel.fromJson(json)).toList();
      } else {
        throw Exception(response['message'] ?? 'Failed to load orders');
      }
    } catch (e) {
      print('Error fetching orders: $e');
      rethrow;
    }
  }

  Future<OrderModel> updateOrderStatus(String orderId, String status) async {
    try {
      final response = await _apiService.put('/orders/$orderId/status', {
        'status': status,
      });
      
      if (response['success'] == true && response['data'] != null) {
        return OrderModel.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Failed to update order');
      }
    } catch (e) {
      print('Error updating order status: $e');
      rethrow;
    }
  }

  Future<OrderModel?> verifyPickupCode(String code) async {
    try {
      final response = await _apiService.post('/orders/verify-pickup', {
        'pickupCode': code,
      });
      
      if (response['success'] == true && response['data'] != null) {
        return OrderModel.fromJson(response['data']);
      } else {
        return null; // Invalid code
      }
    } catch (e) {
      print('Error verifying pickup code: $e');
      return null;
    }
  }

  Future<OrderModel> completeOrder(String orderId) async {
    try {
      final response = await _apiService.put('/orders/$orderId/complete', {});
      
      if (response['success'] == true && response['data'] != null) {
        return OrderModel.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Failed to complete order');
      }
    } catch (e) {
      print('Error completing order: $e');
      rethrow;
    }
  }
}