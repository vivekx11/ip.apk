// Order model for marketplace app

class OrderModel {
  final String id;
  final String userId;
  final String shopId;
  final String shopName;
  final List<OrderItem> items;
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
      items: (json['items'] as List?)
          ?.map((item) => OrderItem.fromJson(item))
          .toList() ?? [],
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

  factory OrderModel.fromFirestore(Map<String, dynamic> data, String id) {
    return OrderModel(
      id: id,
      userId: data['userId'] ?? '',
      shopId: data['shopId'] ?? '',
      shopName: data['shopName'] ?? '',
      items: (data['items'] as List?)
          ?.map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      totalAmount: (data['totalAmount'] ?? 0.0).toDouble(),
      status: data['status'] ?? 'pending',
      orderToken: data['orderToken'] ?? '',
      deliveryAddress: data['deliveryAddress'],
      notes: data['notes'],
      createdAt: data['createdAt'] != null 
          ? (data['createdAt'] is String 
              ? DateTime.parse(data['createdAt'])
              : DateTime.now())
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null 
          ? (data['updatedAt'] is String 
              ? DateTime.parse(data['updatedAt'])
              : null)
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

  bool get canBeAccepted => status == 'pending';
  bool get canBeRejected => status == 'pending';
  bool get canBeMarkedReady => status == 'confirmed' || status == 'preparing';
  bool get canBeCompleted => status == 'ready';
}

class OrderItem {
  final String id;
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String? productImage;

  OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    this.productImage,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['_id'] ?? json['id'],
      productId: json['productId'],
      productName: json['productName'],
      price: (json['price'] ?? 0.0).toDouble(),
      quantity: json['quantity'] ?? 1,
      productImage: json['productImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'productImage': productImage,
    };
  }

  double get totalPrice => price * quantity;
}