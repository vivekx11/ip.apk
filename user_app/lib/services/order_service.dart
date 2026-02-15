import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/app_constants.dart';
import '../models/order_model.dart' as order_model;
import '../models/cart_item_model.dart';

class OrderService {
  static final OrderService _instance = OrderService._internal();
  factory OrderService() => _instance;
  OrderService._internal();

  static const String baseUrl = AppConstants.baseUrl;

  /// Place a new order
  Future<Map<String, dynamic>> placeOrder({
    required String userId,
    required String shopId,
    required List<dynamic> items, // Accept List<Map> or List<CartItemModel>
    required double totalAmount,
    required String customerName,
    String? notes,
  }) async {
    try {
      print('📦 Placing order...');
      print('User ID: $userId');
      print('Shop ID: $shopId');
      print('Items: ${items.length}');
      print('Total: ₹$totalAmount');

      // Convert items to proper format
      final orderItems = items.map((item) {
        if (item is CartItemModel) {
          return {
            'productId': item.productId,
            'productName': item.productName,
            'price': item.price,
            'quantity': item.quantity,
            'productImage': item.imageUrl,
          };
        } else if (item is Map) {
          return {
            'productId': item['productId'],
            'productName': item['productName'],
            'price': item['price'],
            'quantity': item['quantity'],
            'productImage': item['imageUrl'] ?? item['productImage'] ?? '',
          };
        }
        throw Exception('Invalid item type');
      }).toList();

      final response = await http.post(
        Uri.parse('$baseUrl/orders'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'shopId': shopId,
          'items': orderItems,
          'totalAmount': totalAmount,
          'customerName': customerName,
          'notes': notes ?? '',
        }),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout. Please try again.');
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          print('✅ Order placed successfully');
          return data['data'];
        } else {
          throw Exception(data['message'] ?? 'Failed to place order');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to place order');
      }
    } catch (e) {
      print('❌ Error placing order: $e');
      rethrow;
    }
  }

  /// Get user orders
  Future<List<order_model.Order>> getUserOrders(String userId, {int page = 1, int limit = 20}) async {
    try {
      print('📋 Fetching orders for user: $userId');

      final response = await http.get(
        Uri.parse('$baseUrl/orders/user/$userId?page=$page&limit=$limit'),
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
          final List<dynamic> ordersJson = data['data'];
          return ordersJson.map((json) => order_model.Order.fromJson(json)).toList();
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

  /// Get order by ID
  Future<order_model.Order> getOrderById(String orderId) async {
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
          return order_model.Order.fromJson(data['data']);
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
