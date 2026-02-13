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

  void addItem(ProductModel product, {int quantity = 1}) {
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
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (_items.containsKey(productId)) {
      if (quantity <= 0) {
        _items.remove(productId);
      } else {
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
          ),
        );
      }
      notifyListeners();
    }
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
