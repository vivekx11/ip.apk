import 'api_service.dart';

class ShopApiService {
  final ApiService _apiService = ApiService();

  // Get shop by owner ID
  Future<Map<String, dynamic>?> getShopByOwnerId(String ownerId) async {
    try {
      final response = await _apiService.get('/shops?ownerId=$ownerId');
      if (response['success'] == true && response['data'] != null) {
        final shops = response['data'] as List;
        if (shops.isNotEmpty) {
          return shops.first as Map<String, dynamic>;
        }
      }
      return null;
    } catch (e) {
      throw Exception('Failed to load shop: $e');
    }
  }

  // Get shop by ID
  Future<Map<String, dynamic>> getShop(String shopId) async {
    try {
      final response = await _apiService.get('/shops/$shopId');
      if (response['success'] == true) {
        return response['data'];
      }
      throw Exception('Shop not found');
    } catch (e) {
      throw Exception('Failed to load shop: $e');
    }
  }

  // Create new shop
  Future<Map<String, dynamic>> createShop(Map<String, dynamic> shopData) async {
    try {
      final response = await _apiService.post('/shops', shopData);
      if (response['success'] == true) {
        return response['data'];
      }
      throw Exception(response['message'] ?? 'Failed to create shop');
    } catch (e) {
      throw Exception('Failed to create shop: $e');
    }
  }

  // Update shop
  Future<Map<String, dynamic>> updateShop(String shopId, Map<String, dynamic> updates) async {
    try {
      final response = await _apiService.put('/shops/$shopId', updates);
      if (response['success'] == true) {
        return response['data'];
      }
      throw Exception(response['message'] ?? 'Failed to update shop');
    } catch (e) {
      throw Exception('Failed to update shop: $e');
    }
  }

  // Delete shop
  Future<bool> deleteShop(String shopId) async {
    try {
      final response = await _apiService.delete('/shops/$shopId');
      return response['success'] == true;
    } catch (e) {
      throw Exception('Failed to delete shop: $e');
    }
  }

  // Toggle shop open/close status
  Future<Map<String, dynamic>> toggleShopStatus(String shopId) async {
    try {
      final response = await _apiService.put('/shops/$shopId/toggle-status', {});
      if (response['success'] == true) {
        return response['data'];
      }
      throw Exception(response['message'] ?? 'Failed to toggle shop status');
    } catch (e) {
      throw Exception('Failed to toggle shop status: $e');
    }
  }

  // Get all shops (for admin or listing)
  Future<List<Map<String, dynamic>>> getAllShops({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    try {
      String endpoint = '/shops?page=$page&limit=$limit';
      if (search != null && search.isNotEmpty) {
        endpoint += '&search=$search';
      }
      
      final response = await _apiService.get(endpoint);
      if (response['success'] == true) {
        return List<Map<String, dynamic>>.from(response['data'] ?? []);
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load shops: $e');
    }
  }
}
