import '../models/product_model.dart';
import 'api_service.dart';

class ProductService {
  final ApiService _apiService = ApiService();

  // Get all products
  Future<List<Product>> getAllProducts() async {
    try {
      final response = await _apiService.get('/products');
      final List<dynamic> productsJson = response['data'] ?? [];
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  // Get products by shop
  Future<List<Product>> getProductsByShop(String shopId) async {
    try {
      final response = await _apiService.get('/products?shopId=$shopId');
      final List<dynamic> productsJson = response['data'] ?? [];
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load shop products: $e');
    }
  }

  // Get product by ID
  Future<Product> getProductById(String productId) async {
    try {
      final response = await _apiService.get('/products/$productId');
      return Product.fromJson(response['data']);
    } catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }
}
