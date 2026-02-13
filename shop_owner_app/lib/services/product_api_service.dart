import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductApiService {
  static final ProductApiService _instance = ProductApiService._internal();
  factory ProductApiService() => _instance;
  ProductApiService._internal();

  // Production backend URL
  static const String API_BASE_URL = 'https://instantpick-backend.onrender.com/api';

  /// Get all products (with optional filters)
  Future<Map<String, dynamic>> getProducts({
    String? shopId,
    String? category,
    String? search,
    bool? isAvailable,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      // Build query parameters
      Map<String, String> queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (shopId != null) queryParams['shopId'] = shopId;
      if (category != null) queryParams['category'] = category;
      if (search != null) queryParams['search'] = search;
      if (isAvailable != null) queryParams['isAvailable'] = isAvailable.toString();

      final uri = Uri.parse('$API_BASE_URL/products').replace(queryParameters: queryParams);
      
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('❌ Error fetching products: $e');
      rethrow;
    }
  }

  /// Get single product by ID
  Future<Map<String, dynamic>> getProduct(String productId) async {
    try {
      final response = await http.get(
        Uri.parse('$API_BASE_URL/products/$productId'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load product');
      }
    } catch (e) {
      print('❌ Error fetching product: $e');
      rethrow;
    }
  }

  /// Update product
  Future<Map<String, dynamic>> updateProduct(
    String productId,
    Map<String, dynamic> updates,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$API_BASE_URL/products/$productId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updates),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to update product');
      }
    } catch (e) {
      print('❌ Error updating product: $e');
      rethrow;
    }
  }

  /// Delete product
  Future<bool> deleteProduct(String productId) async {
    try {
      final response = await http.delete(
        Uri.parse('$API_BASE_URL/products/$productId'),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('❌ Error deleting product: $e');
      return false;
    }
  }

  /// Toggle product availability
  Future<Map<String, dynamic>> toggleProductAvailability(String productId) async {
    try {
      final response = await http.put(
        Uri.parse('$API_BASE_URL/products/$productId/toggle-availability'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to toggle availability');
      }
    } catch (e) {
      print('❌ Error toggling availability: $e');
      rethrow;
    }
  }

  /// Get categories for a shop
  Future<List<String>> getShopCategories(String shopId) async {
    try {
      final response = await http.get(
        Uri.parse('$API_BASE_URL/products/shop/$shopId/categories'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<String>.from(data['data']);
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('❌ Error fetching categories: $e');
      rethrow;
    }
  }
}
