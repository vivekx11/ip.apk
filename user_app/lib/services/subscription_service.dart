import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionService {
  static const String _subscriptionsKey = 'shop_subscriptions';
  
  List<String> _subscribedShopIds = [];

  // Get all subscribed shop IDs
  Future<List<String>> getSubscribedShops() async {
    await _loadSubscriptions();
    return _subscribedShopIds;
  }

  // Check if user is subscribed to a shop
  Future<bool> isSubscribed(String shopId) async {
    await _loadSubscriptions();
    return _subscribedShopIds.contains(shopId);
  }

  // Subscribe to a shop
  Future<void> subscribe(String shopId) async {
    await _loadSubscriptions();
    if (!_subscribedShopIds.contains(shopId)) {
      _subscribedShopIds.add(shopId);
      await _saveSubscriptions();
    }
  }

  // Unsubscribe from a shop
  Future<void> unsubscribe(String shopId) async {
    await _loadSubscriptions();
    _subscribedShopIds.remove(shopId);
    await _saveSubscriptions();
  }

  // Toggle subscription
  Future<bool> toggleSubscription(String shopId) async {
    await _loadSubscriptions();
    if (_subscribedShopIds.contains(shopId)) {
      await unsubscribe(shopId);
      return false; // Now unsubscribed
    } else {
      await subscribe(shopId);
      return true; // Now subscribed
    }
  }

  // Get subscription count
  Future<int> getSubscriptionCount() async {
    await _loadSubscriptions();
    return _subscribedShopIds.length;
  }

  // Clear all subscriptions
  Future<void> clearAll() async {
    _subscribedShopIds.clear();
    await _saveSubscriptions();
  }

  // Private: Load subscriptions from storage
  Future<void> _loadSubscriptions() async {
    final prefs = await SharedPreferences.getInstance();
    final subscriptionsJson = prefs.getString(_subscriptionsKey);
    
    if (subscriptionsJson != null) {
      final List<dynamic> decoded = json.decode(subscriptionsJson);
      _subscribedShopIds = decoded.cast<String>();
    }
  }

  // Private: Save subscriptions to storage
  Future<void> _saveSubscriptions() async {
    final prefs = await SharedPreferences.getInstance();
    final subscriptionsJson = json.encode(_subscribedShopIds);
    await prefs.setString(_subscriptionsKey, subscriptionsJson);
  }
}
