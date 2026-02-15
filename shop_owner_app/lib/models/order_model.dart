// Order model for marketplace app

class OrderModel {
  final String id;
  final String userId;
  final String shopId;
  final String shopName;
  final String customerName;
  final List<OrderItem> items;
  final double totalAmount;
  final String status;
  final String pickupPin; // 4-digit PIN
  final String orderNumber; // Formatted order number
  final String? notes;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? completedAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.shopId,
    required this.shopName,
    required this.customerName,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.pickupPin,
    required this.orderNumber,
    this.notes,
    required this.createdAt,
    this.acceptedAt,
    this.completedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      shopId: json['shopId'] is Map ? json['shopId']['_id'] : json['shopId'] ?? '',
      shopName: json['shopName'] ?? '',
      customerName: json['customerName'] ?? 'Guest',
      items: (json['items'] as List?)
          ?.map((item) => OrderItem.fromJson(item))
          .toList() ?? [],
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'Pending',
      pickupPin: json['pickupPin'] ?? json['orderToken'] ?? '', // Support both old and new
      orderNumber: json['orderNumber'] ?? 'ORD${json['_id']?.toString().substring(0, 8).toUpperCase() ?? ''}',
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'shopId': shopId,
      'shopName': shopName,
      'customerName': customerName,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status,
      'pickupPin': pickupPin,
      'orderNumber': orderNumber,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'acceptedAt': acceptedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  String get statusDisplayName {
    switch (status) {
      case 'Pending':
        return 'Order Placed';
      case 'Accepted':
        return 'Accepted';
      case 'Completed':
        return 'Completed';
      case 'Cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  bool get canBeAccepted => status == 'Pending';
  bool get canBeRejected => status == 'Pending';
  bool get canBeCompleted => status == 'Accepted';
  
  // Legacy support
  String get orderToken => pickupPin;
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