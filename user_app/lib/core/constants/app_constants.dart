class AppConstants {
  // ============================================
  // 🌐 API CONFIGURATION
  // ============================================
  // PRODUCTION: Use your deployed backend URL
  // Example: 'https://your-app.onrender.com/api'
  // 
  // LOCAL TESTING: Use your computer's IP
  // Example: 'http://192.168.1.100:3001/api'
  //
  // NGROK (Temporary): Use ngrok URL
  // Example: 'https://abc123.ngrok.io/api'
  // ============================================
  
  static const String baseUrl = 'http://localhost:3001/api';
  
  // ⚠️ CHANGE THIS BEFORE BUILDING FOR PRODUCTION ⚠️
  // Uncomment one of these based on your setup:
  
  // For Render.com deployment:
  // static const String baseUrl = 'https://marketplace-backend.onrender.com/api';
  
  // For Railway deployment:
  // static const String baseUrl = 'https://your-app.railway.app/api';
  
  // For local network testing (replace with your IP):
  // static const String baseUrl = 'http://192.168.1.100:3001/api';
  
  // For ngrok testing:
  // static const String baseUrl = 'https://your-ngrok-url.ngrok.io/api';
  
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