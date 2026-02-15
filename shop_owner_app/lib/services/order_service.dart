import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderService {
  static final OrderService _instance = OrderService._internal();
  factory OrderService() => _instance;
  OrderService._internal();

  // Production backend URL
  static const String baseUrl = 'https://instantpick-backend.onrender.com/api';

  /// Get shop orders by status
  Future<List<Map<String, dynamic>>> getShopOrders(
    String shopId, {
    String? status,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      print('📋 Fetching orders for shop: $shopId');

      String url = '$baseUrl/orders/shop/$shopId?page=$page&limit=$limit';
      if (status != null && status.isNotEmpty) {
        url += '&status=$status';
      }

      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout. Please try again.');
        },
      );

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return List<Map<String, dynamic>>.from(data['data']);
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch orders');
        }
      } else {
        throw Exception('Failed to fetch orders');
      }
    } catch (e) {
      print('❌ Error fetching orders: $e');
      rethrow;
    }
  }

  /// Update order status (Accept/Cancel)
  Future<Map<String, dynamic>> updateOrderStatus(
    String orderId,
    String status, {
    String? cancellationReason,
  }) async {
    try {
      print('📝 Updating order status: $orderId → $status');

      final response = await http.put(
        Uri.parse('$baseUrl/orders/$orderId/status'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'status': status,
          if (cancellationReason != null) 'cancellationReason': cancellationReason,
        }),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout. Please try again.');
        },
      );

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          print('✅ Order status updated');
          return data['data'];
        } else {
          throw Exception(data['message'] ?? 'Failed to update status');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to update status');
      }
    } catch (e) {
      print('❌ Error updating status: $e');
      rethrow;
    }
  }

  /// Verify PIN and complete order
  Future<Map<String, dynamic>> verifyPinAndComplete(
    String orderId,
    String pickupPin,
  ) async {
    try {
      print('🔍 Verifying PIN for order: $orderId');

      final response = await http.post(
        Uri.parse('$baseUrl/orders/verify-pin'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'orderId': orderId,
          'pickupPin': pickupPin,
        }),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout. Please try again.');
        },
      );

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          print('✅ PIN verified, order completed');
          return data['data'];
        } else {
          throw Exception(data['message'] ?? 'Invalid PIN');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to verify PIN');
      }
    } catch (e) {
      print('❌ Error verifying PIN: $e');
      rethrow;
    }
  }

  /// Get order by ID
  Future<Map<String, dynamic>> getOrderById(String orderId) async {
    try {
      print('🔍 Fetching order: $orderId');

      final response = await http.get(
        Uri.parse('$baseUrl/orders/$orderId'),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout. Please try again.');
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return data['data'];
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch order');
        }
      } else {
        throw Exception('Failed to fetch order');
      }
    } catch (e) {
      print('❌ Error fetching order: $e');
      rethrow;
    }
  }
}
