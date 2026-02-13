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
      
      print('🔍 Fetching products from: $uri');
      
      final response = await http.get(uri);

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Fetched ${data['data'].length} products');
        return data;
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
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

  /// Get products by shop
  Future<List<dynamic>> getProductsByShop(String shopId) async {
    try {
      final result = await getProducts(shopId: shopId, isAvailable: true);
      return result['data'] ?? [];
    } catch (e) {
      print('❌ Error fetching shop products: $e');
      rethrow;
    }
  }

  /// Search products
  Future<List<dynamic>> searchProducts(String query) async {
    try {
      final result = await getProducts(search: query, isAvailable: true);
      return result['data'] ?? [];
    } catch (e) {
      print('❌ Error searching products: $e');
      rethrow;
    }
  }
}
