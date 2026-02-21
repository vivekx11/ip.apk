class ProductNotification {
  final String id;
  final String shopId;
  final String shopName;
  final String productId;
  final String productName;
  final String productImage;
  final double productPrice;
  final String message;
  final DateTime createdAt;
  bool isRead;

  ProductNotification({
    required this.id,
    required this.shopId,
    required this.shopName,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.message,
    required this.createdAt,
    this.isRead = false,
  });

  factory ProductNotification.fromJson(Map<String, dynamic> json) {
    return ProductNotification(
      id: json['_id'] ?? json['id'] ?? '',
      shopId: json['shopId'] ?? '',
      shopName: json['shopName'] ?? '',
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      productImage: json['productImage'] ?? '',
      productPrice: (json['productPrice'] ?? 0).toDouble(),
      message: json['message'] ?? '',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shopId': shopId,
      'shopName': shopName,
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'productPrice': productPrice,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
    };
  }
}
