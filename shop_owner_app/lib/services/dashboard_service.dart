import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/app_constants.dart';

class DashboardService {
  // Get lightweight dashboard summary (fast initial load)
  Future<Map<String, dynamic>> getDashboardSummary(String ownerId) async {
    try {
      final url = Uri.parse('${AppConstants.baseUrl}/dashboard/summary/$ownerId');
      
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        print('✅ Dashboard summary loaded in ${data['responseTime']}');
        return data['data'];
      } else {
        throw Exception(data['message'] ?? 'Failed to load dashboard');
      }
    } catch (e) {
      print('❌ Dashboard summary error: $e');
      rethrow;
    }
  }

  // Get paginated products (load on demand)
  Future<Map<String, dynamic>> getProducts(String shopId, {int page = 1, int limit = 10, bool? isAvailable}) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (isAvailable != null) 'isAvailable': isAvailable.toString(),
      };
      
      final url = Uri.parse('${AppConstants.baseUrl}/dashboard/products/$shopId')
          .replace(queryParameters: queryParams);
      
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        print('✅ Products loaded (page $page) in ${data['responseTime']}');
        return {
          'products': data['data'],
          'pagination': data['pagination'],
        };
      } else {
        throw Exception(data['message'] ?? 'Failed to load products');
      }
    } catch (e) {
      print('❌ Products error: $e');
      rethrow;
    }
  }

  // Get paginated orders (load on demand)
  Future<Map<String, dynamic>> getOrders(String shopId, {int page = 1, int limit = 10, String? status}) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (status != null) 'status': status,
      };
      
      final url = Uri.parse('${AppConstants.baseUrl}/dashboard/orders/$shopId')
          .replace(queryParameters: queryParams);
      
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        print('✅ Orders loaded (page $page) in ${data['responseTime']}');
        return {
          'orders': data['data'],
          'pagination': data['pagination'],
        };
      } else {
        throw Exception(data['message'] ?? 'Failed to load orders');
      }
    } catch (e) {
      print('❌ Orders error: $e');
      rethrow;
    }
  }

  // Get recent activity (lightweight)
  Future<List<dynamic>> getRecentActivity(String shopId, {int limit = 5}) async {
    try {
      final url = Uri.parse('${AppConstants.baseUrl}/dashboard/recent-activity/$shopId?limit=$limit');
      
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        print('✅ Recent activity loaded in ${data['responseTime']}');
        return data['data'];
      } else {
        throw Exception(data['message'] ?? 'Failed to load activity');
      }
    } catch (e) {
      print('❌ Recent activity error: $e');
      rethrow;
    }
  }

  // Get stats (charts data)
  Future<Map<String, dynamic>> getStats(String shopId, {int days = 7}) async {
    try {
      final url = Uri.parse('${AppConstants.baseUrl}/dashboard/stats/$shopId?days=$days');
      
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        print('✅ Stats loaded in ${data['responseTime']}');
        return data['data'];
      } else {
        throw Exception(data['message'] ?? 'Failed to load stats');
      }
    } catch (e) {
      print('❌ Stats error: $e');
      rethrow;
    }
  }
}
