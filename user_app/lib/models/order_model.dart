import 'cart_item_model.dart';
import 'product_model.dart';

enum OrderStatus {
  placed,
  accepted,
  ready,
  completed,
  cancelled,
}

class Order {
  final String id;
  final String userId;
  final String shopId;
  final String shopName;
  final String shopAddress;
  final List<Product> products;
  final double totalAmount;
  final String pickupCode;
  final OrderStatus status;
  final String? notes;
  final DateTime createdAt;
  final DateTime expiresAt;

  Order({
    required this.id,
    required this.userId,
    required this.shopId,
    required this.shopName,
    required this.shopAddress,
    required this.products,
    required this.totalAmount,
    required this.pickupCode,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.expiresAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'] ?? json['id'],
      userId: json['userId'],
      shopId: json['shopId'],
      shopName: json['shopName'],
      shopAddress: json['shopAddress'],
      products: (json['products'] as List)
          .map((product) => Product.fromJson(product))
          .toList(),
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      pickupCode: json['pickupCode'],
      status: OrderStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => OrderStatus.placed,
      ),
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      expiresAt: DateTime.parse(json['expiresAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'shopId': shopId,
      'shopName': shopName,
      'shopAddress': shopAddress,
      'products': products.map((product) => product.toJson()).toList(),
      'totalAmount': totalAmount,
      'pickupCode': pickupCode,
      'status': status.toString().split('.').last,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  String get statusDisplayName {
    switch (status) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.accepted:
        return 'Accepted by Shop';
      case OrderStatus.ready:
        return 'Ready for Pickup';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

// Keep the old model for backward compatibility
class OrderModel {
  final String id;
  final String userId;
  final String shopId;
  final String shopName;
  final List<CartItemModel> items;
  final double totalAmount;
  final String status;
  final String orderToken;
  final String? deliveryAddress;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.shopId,
    required this.shopName,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.orderToken,
    this.deliveryAddress,
    this.notes,
    required this.createdAt,
    this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'] ?? json['id'],
      userId: json['userId'],
      shopId: json['shopId'],
      shopName: json['shopName'],
      items: (json['items'] as List)
          .map((item) => CartItemModel.fromJson(item))
          .toList(),
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      status: json['status'],
      orderToken: json['orderToken'],
      deliveryAddress: json['deliveryAddress'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'shopId': shopId,
      'shopName': shopName,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status,
      'orderToken': orderToken,
      'deliveryAddress': deliveryAddress,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  String get statusDisplayName {
    switch (status) {
      case 'pending':
        return 'Order Placed';
      case 'confirmed':
        return 'Confirmed';
      case 'preparing':
        return 'Preparing';
      case 'ready':
        return 'Ready for Pickup';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }
}