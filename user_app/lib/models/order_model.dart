import 'cart_item_model.dart';
import 'product_model.dart';

enum OrderStatus {
  Pending,
  Accepted,
  Completed,
  Cancelled,
}

class Order {
  final String id;
  final String userId;
  final String shopId;
  final String shopName;
  final String shopAddress;
  final List<OrderItem> items;
  final double totalAmount;
  final String pickupPin; // 4-digit PIN
  final String orderNumber; // Formatted order number
  final OrderStatus status;
  final String customerName;
  final String? notes;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? completedAt;

  Order({
    required this.id,
    required this.userId,
    required this.shopId,
    required this.shopName,
    required this.shopAddress,
    required this.items,
    required this.totalAmount,
    required this.pickupPin,
    required this.orderNumber,
    required this.status,
    required this.customerName,
    this.notes,
    required this.createdAt,
    this.acceptedAt,
    this.completedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      shopId: json['shopId'] is Map ? json['shopId']['_id'] : json['shopId'] ?? '',
      shopName: json['shopName'] ?? '',
      shopAddress: json['shopAddress'] ?? '',
      items: (json['items'] as List? ?? [])
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      pickupPin: json['pickupPin'] ?? '',
      orderNumber: json['orderNumber'] ?? 'ORD${json['_id']?.toString().substring(0, 8).toUpperCase() ?? ''}',
      status: _parseStatus(json['status']),
      customerName: json['customerName'] ?? 'Guest',
      notes: json['notes'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      acceptedAt: json['acceptedAt'] != null 
          ? DateTime.parse(json['acceptedAt']) 
          : null,
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt']) 
          : null,
    );
  }

  static OrderStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return OrderStatus.Pending;
      case 'accepted':
        return OrderStatus.Accepted;
      case 'completed':
        return OrderStatus.Completed;
      case 'cancelled':
        return OrderStatus.Cancelled;
      default:
        return OrderStatus.Pending;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'shopId': shopId,
      'shopName': shopName,
      'shopAddress': shopAddress,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'pickupPin': pickupPin,
      'orderNumber': orderNumber,
      'status': status.toString().split('.').last,
      'customerName': customerName,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'acceptedAt': acceptedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  String get statusDisplayName {
    switch (status) {
      case OrderStatus.Pending:
        return 'Order Placed';
      case OrderStatus.Accepted:
        return 'Accepted by Shop';
      case OrderStatus.Completed:
        return 'Completed';
      case OrderStatus.Cancelled:
        return 'Cancelled';
    }
  }

  String get statusEmoji {
    switch (status) {
      case OrderStatus.Pending:
        return '⏳';
      case OrderStatus.Accepted:
        return '✅';
      case OrderStatus.Completed:
        return '🎉';
      case OrderStatus.Cancelled:
        return '❌';
    }
  }
}

// Order Item model
class OrderItem {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String? productImage;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    this.productImage,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      quantity: json['quantity'] ?? 1,
      productImage: json['productImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'productImage': productImage,
    };
  }

  double get subtotal => price * quantity;
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