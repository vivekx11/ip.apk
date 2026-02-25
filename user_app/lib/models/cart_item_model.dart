class CartItemModel {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String shopId;
  final String shopName;
  final String imageUrl;
  final int availableStock; // Track available stock for validation

  CartItemModel({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.shopId,
    required this.shopName,
    this.imageUrl = '',
    this.availableStock = 100, // Default to 100 if not specified
  });

  double get totalPrice => price * quantity;

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'],
      productName: json['productName'],
      price: (json['price'] ?? 0.0).toDouble(),
      quantity: json['quantity'],
      shopId: json['shopId'],
      shopName: json['shopName'],
      imageUrl: json['imageUrl'] ?? '',
      availableStock: json['availableStock'] ?? 100,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'shopId': shopId,
      'shopName': shopName,
      'imageUrl': imageUrl,
      'availableStock': availableStock,
    };
  }

  CartItemModel copyWith({
    String? productId,
    String? productName,
    double? price,
    int? quantity,
    String? shopId,
    String? shopName,
    String? imageUrl,
    int? availableStock,
  }) {
    return CartItemModel(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      shopId: shopId ?? this.shopId,
      shopName: shopName ?? this.shopName,
      imageUrl: imageUrl ?? this.imageUrl,
      availableStock: availableStock ?? this.availableStock,
    );
  }
}