import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItemModel> _items = {};

  Map<String, CartItemModel> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  List<CartItemModel> get cartItems => _items.values.toList();

  // Returns error message if item cannot be added, null if successful
  String? addItem(ProductModel product, {int quantity = 1}) {
    // Check if product is available
    if (!product.isAvailable) {
      return 'Product is not available';
    }

    // Calculate total quantity that would be in cart
    int totalQuantity = quantity;
    if (_items.containsKey(product.id)) {
      totalQuantity += _items[product.id]!.quantity;
    }

    // Check if total quantity exceeds available stock
    if (totalQuantity > product.stock) {
      return 'Not available in store. Only ${product.stock} items available';
    }

    // Add or update item in cart
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingItem) => CartItemModel(
          productId: existingItem.productId,
          productName: existingItem.productName,
          price: existingItem.price,
          quantity: existingItem.quantity + quantity,
          shopId: existingItem.shopId,
          shopName: existingItem.shopName,
          imageUrl: existingItem.imageUrl,
          availableStock: product.stock,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItemModel(
          productId: product.id,
          productName: product.name,
          price: product.price,
          quantity: quantity,
          shopId: product.shopId,
          shopName: product.shopName,
          imageUrl: product.imageUrls.isNotEmpty ? product.imageUrls.first : '',
          availableStock: product.stock,
        ),
      );
    }
    notifyListeners();
    return null; // Success
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  // Returns error message if quantity cannot be updated, null if successful
  String? updateQuantity(String productId, int quantity) {
    if (_items.containsKey(productId)) {
      if (quantity <= 0) {
        _items.remove(productId);
        notifyListeners();
        return null;
      }

      final existingItem = _items[productId]!;
      
      // Check stock availability using stored availableStock
      if (quantity > existingItem.availableStock) {
        return 'Not available in store. Only ${existingItem.availableStock} items available';
      }

      _items.update(
        productId,
        (existingItem) => CartItemModel(
          productId: existingItem.productId,
          productName: existingItem.productName,
          price: existingItem.price,
          quantity: quantity,
          shopId: existingItem.shopId,
          shopName: existingItem.shopName,
          imageUrl: existingItem.imageUrl,
          availableStock: existingItem.availableStock,
        ),
      );
      notifyListeners();
    }
    return null; // Success
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  bool hasItemsFromShop(String shopId) {
    return _items.values.any((item) => item.shopId == shopId);
  }

  void clearShopItems(String shopId) {
    _items.removeWhere((key, item) => item.shopId == shopId);
    notifyListeners();
  }

  List<CartItemModel> getShopItems(String shopId) {
    return _items.values.where((item) => item.shopId == shopId).toList();
  }
}
