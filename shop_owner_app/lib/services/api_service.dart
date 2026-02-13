import 'dart:convert';
import 'package:http/http.dart' as http;
import 'network_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // ============================================
  // 🌐 PRODUCTION URL - RENDER.COM
  // ============================================
  static const String baseUrl = 'https://instantpick-backend.onrender.com/api';
  
  String? _authToken;
  final NetworkService _networkService = NetworkService();

  void setAuthToken(String token) {
    _authToken = token;
  }

  void clearAuthToken() {
    _authToken = null;
  }

  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
    };
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }

  Future<void> _checkConnectivity() async {
    if (!await _networkService.hasInternetConnection()) {
      throw Exception('No internet connection. Please check your network.');
    }
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    await _checkConnectivity();
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
      ).timeout(const Duration(seconds: 30));
      return _handleResponse(response);
    } catch (e) {
      if (e.toString().contains('No internet connection')) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    await _checkConnectivity();
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 30));
      return _handleResponse(response);
    } catch (e) {
      if (e.toString().contains('No internet connection')) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    await _checkConnectivity();
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 30));
      return _handleResponse(response);
    } catch (e) {
      if (e.toString().contains('No internet connection')) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    await _checkConnectivity();
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
      ).timeout(const Duration(seconds: 30));
      return _handleResponse(response);
    } catch (e) {
      if (e.toString().contains('No internet connection')) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final data = jsonDecode(response.body);
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'API Error: ${response.statusCode}');
    }
  }
}