class AppConstants {
  // API Base URL - PRODUCTION
  static const String baseUrl = 'https://instantpick-backend.onrender.com/api';
  
  // For local development, uncomment below:
  // static const String baseUrl = 'http://10.0.2.2:5000/api'; // Android Emulator
  // static const String baseUrl = 'http://localhost:5000/api'; // iOS Simulator
  // static const String baseUrl = 'http://YOUR_IP:5000/api'; // Physical Device
  
  // App Info
  static const String appName = 'Shop Owner Dashboard';
  static const String appVersion = '1.0.0';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Image Upload
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];
  
  // Order Status
  static const String orderStatusPending = 'Pending';
  static const String orderStatusAccepted = 'Accepted';
  static const String orderStatusCompleted = 'Completed';
  static const String orderStatusCancelled = 'Cancelled';
  
  // Shop Categories
  static const List<String> shopCategories = [
    'Grocery',
    'Electronics',
    'Fashion',
    'Food & Beverages',
    'Health & Beauty',
    'Home & Garden',
    'Sports & Fitness',
    'Books & Stationery',
    'Toys & Games',
    'Other',
  ];
}
