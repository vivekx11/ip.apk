import 'api_service.dart';

class OrderService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> placeOrder({
    required String userId,
    required String shopId,
    required List<Map<String, dynamic>> items,
    required double totalAmount,
    required String customerName,
    String? notes,
  }) async {
    try {
      final response = await _apiService.post('/orders', {
        'userId': userId,
        'shopId': shopId,
        'items': items,
        'totalAmount': totalAmount,
        'customerName': customerName,
        'notes': notes ?? '',
      });
      return response;
    } catch (e) {
      throw Exception('Failed to place order: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getUserOrders(String userId) async {
    try {
      final response = await _apiService.get('/orders/user/$userId');
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } catch (e) {
      throw Exception('Failed to load orders: $e');
    }
  }

  Future<Map<String, dynamic>> getOrderById(String orderId) async {
    try {
      final response = await _apiService.get('/orders/$orderId');
      return response['data'];
    } catch (e) {
      throw Exception('Failed to load order: $e');
    }
  }

  Future<Map<String, dynamic>> verifyPickupCode(String pickupCode) async {
    try {
      final response = await _apiService.get('/orders/verify/$pickupCode');
      return response;
    } catch (e) {
      throw Exception('Failed to verify pickup code: $e');
    }
  }
}
