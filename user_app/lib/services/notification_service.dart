import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_model.dart';
import 'subscription_service.dart';

class NotificationService {
  static const String _notificationsKey = 'product_notifications';
  static const String _lastCheckKey = 'last_notification_check';
  
  final SubscriptionService _subscriptionService = SubscriptionService();
  List<ProductNotification> _notifications = [];
  
  // Get all notifications
  Future<List<ProductNotification>> getNotifications() async {
    await _loadNotifications();
    return _notifications;
  }

  // Get unread notifications count
  Future<int> getUnreadCount() async {
    await _loadNotifications();
    return _notifications.where((n) => !n.isRead).length;
  }

  // Add new notification (only if user is subscribed to the shop)
  Future<void> addNotification(ProductNotification notification) async {
    // Check if user is subscribed to this shop
    final isSubscribed = await _subscriptionService.isSubscribed(notification.shopId);
    
    if (isSubscribed) {
      await _loadNotifications();
      _notifications.insert(0, notification);
      await _saveNotifications();
    }
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    await _loadNotifications();
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index].isRead = true;
      await _saveNotifications();
    }
  }

  // Mark all as read
  Future<void> markAllAsRead() async {
    await _loadNotifications();
    for (var notification in _notifications) {
      notification.isRead = true;
    }
    await _saveNotifications();
  }

  // Clear all notifications
  Future<void> clearAll() async {
    _notifications.clear();
    await _saveNotifications();
  }

  // Delete specific notification
  Future<void> deleteNotification(String notificationId) async {
    await _loadNotifications();
    _notifications.removeWhere((n) => n.id == notificationId);
    await _saveNotifications();
  }

  // Check for new products (simulate notification)
  Future<void> checkForNewProducts(List<dynamic> currentProducts) async {
    final prefs = await SharedPreferences.getInstance();
    final lastCheck = prefs.getString(_lastCheckKey);
    
    if (lastCheck != null) {
      final lastCheckTime = DateTime.parse(lastCheck);
      
      // Find products added after last check
      for (var product in currentProducts) {
        if (product.createdAt.isAfter(lastCheckTime)) {
          final notification = ProductNotification(
            id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
            shopId: product.shopId ?? '',
            shopName: product.shopName ?? 'Unknown Shop',
            productId: product.id ?? '',
            productName: product.name ?? '',
            productImage: product.imageUrl ?? '',
            productPrice: product.price ?? 0.0,
            message: '${product.shopName} added a new product: ${product.name}',
            createdAt: product.createdAt,
          );
          await addNotification(notification);
        }
      }
    }
    
    // Update last check time
    await prefs.setString(_lastCheckKey, DateTime.now().toIso8601String());
  }

  // Private: Load notifications from storage
  Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = prefs.getString(_notificationsKey);
    
    if (notificationsJson != null) {
      final List<dynamic> decoded = json.decode(notificationsJson);
      _notifications = decoded
          .map((item) => ProductNotification.fromJson(item))
          .toList();
    }
  }

  // Private: Save notifications to storage
  Future<void> _saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = json.encode(
      _notifications.map((n) => n.toJson()).toList(),
    );
    await prefs.setString(_notificationsKey, notificationsJson);
  }

  // Simulate receiving a notification for new product (only if subscribed)
  Future<void> simulateNewProductNotification({
    required String shopId,
    required String shopName,
    required String productId,
    required String productName,
    required String productImage,
    required double productPrice,
  }) async {
    // Check if user is subscribed to this shop
    final isSubscribed = await _subscriptionService.isSubscribed(shopId);
    
    if (isSubscribed) {
      final notification = ProductNotification(
        id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
        shopId: shopId,
        shopName: shopName,
        productId: productId,
        productName: productName,
        productImage: productImage,
        productPrice: productPrice,
        message: '$shopName added a new product: $productName',
        createdAt: DateTime.now(),
      );
      
      await addNotification(notification);
    }
  }
}
