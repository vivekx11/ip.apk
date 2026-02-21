import '../services/notification_service.dart';

/// Helper class to simulate notifications for testing
class NotificationHelper {
  static final NotificationService _notificationService = NotificationService();

  /// Simulate a new product notification
  /// Call this when you want to test the notification feature
  static Future<void> simulateNewProduct({
    required String shopId,
    required String shopName,
    required String productId,
    required String productName,
    required String productImage,
    required double productPrice,
  }) async {
    await _notificationService.simulateNewProductNotification(
      shopId: shopId,
      shopName: shopName,
      productId: productId,
      productName: productName,
      productImage: productImage,
      productPrice: productPrice,
    );
  }

  /// Create sample notifications for testing
  static Future<void> createSampleNotifications() async {
    // Sample notification 1
    await simulateNewProduct(
      shopId: 'shop1',
      shopName: 'Fresh Mart',
      productId: 'prod1',
      productName: 'Organic Apples',
      productImage: '',
      productPrice: 150.00,
    );

    // Sample notification 2
    await simulateNewProduct(
      shopId: 'shop2',
      shopName: 'Tech Hub',
      productId: 'prod2',
      productName: 'Wireless Earbuds',
      productImage: '',
      productPrice: 2499.00,
    );

    // Sample notification 3
    await simulateNewProduct(
      shopId: 'shop3',
      shopName: 'Fashion Store',
      productId: 'prod3',
      productName: 'Cotton T-Shirt',
      productImage: '',
      productPrice: 499.00,
    );
  }
}
