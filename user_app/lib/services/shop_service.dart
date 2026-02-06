import '../models/shop_model.dart';
import '../models/product_model.dart';
import 'api_service.dart';

class ShopService {
  static final ShopService _instance = ShopService._internal();
  factory ShopService() => _instance;
  ShopService._internal();

  final ApiService _apiService = ApiService();

  Future<List<Shop>> getShops() async {
    try {
      final response = await _apiService.get('/shops');
      
      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> shopsData = response['data'];
        return shopsData.map((json) => Shop.fromJson(json)).toList();
      } else {
        throw Exception(response['message'] ?? 'Failed to load shops');
      }
    } catch (e) {
      print('Error fetching shops: $e');
      rethrow;
    }
  }

  Future<Shop> getShopById(String shopId) async {
    try {
      final response = await _apiService.get('/shops/$shopId');
      
      if (response['success'] == true && response['data'] != null) {
        return Shop.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Failed to load shop');
      }
    } catch (e) {
      print('Error fetching shop: $e');
      rethrow;
    }
  }

  Future<List<Product>> getShopProducts(String shopId) async {
    try {
      final response = await _apiService.get('/products/shop/$shopId');
      
      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> productsData = response['data'];
        return productsData.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception(response['message'] ?? 'Failed to load products');
      }
    } catch (e) {
      print('Error fetching shop products: $e');
      rethrow;
    }
  }
}