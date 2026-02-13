class AppConstants {
  // ============================================
  // 🌐 PRODUCTION URL - RENDER.COM
  // ============================================
  static const String baseUrl = 'https://instantpick-backend.onrender.com/api';
  
  // API Endpoints
  static const String authUrl = '$baseUrl/auth';
  static const String userUrl = '$baseUrl/users';
  static const String shopUrl = '$baseUrl/shops';
  static const String productUrl = '$baseUrl/products';
  static const String orderUrl = '$baseUrl/orders';

  // App Info
  static const String appName = 'Local Marketplace';
  static const String userAppName = 'Customer App';
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String cartKey = 'cart_items';
  
  // Order Status
  static const String orderPending = 'pending';
  static const String orderConfirmed = 'confirmed';
  static const String orderPreparing = 'preparing';
  static const String orderReady = 'ready';
  static const String orderCompleted = 'completed';
  static const String orderCancelled = 'cancelled';
}