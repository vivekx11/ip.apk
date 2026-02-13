class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String shopId;
  final String shopName;
  final String category;
  final List<String> imageUrls;
  final bool isAvailable;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.shopId,
    required this.shopName,
    required this.category,
    required this.imageUrls,
    required this.isAvailable,
  });

  String get imageUrl => imageUrls.isNotEmpty ? imageUrls.first : '';

  factory Product.fromJson(Map<String, dynamic> json) {
    // Handle both imageUrl (string) and imageUrls (array)
    List<String> images = [];
    if (json['imageUrls'] != null && json['imageUrls'] is List) {
      images = List<String>.from(json['imageUrls']);
    } else if (json['imageUrl'] != null && json['imageUrl'].toString().isNotEmpty) {
      images = [json['imageUrl'].toString()];
    }

    return Product(
      id: json['_id'] ?? json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      shopId: json['shopId'] ?? '',
      shopName: json['shopName'] ?? '',
      category: json['category'] ?? 'General',
      imageUrls: images,
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'shopId': shopId,
      'shopName': shopName,
      'category': category,
      'imageUrls': imageUrls,
      'isAvailable': isAvailable,
    };
  }

  // Convert to ProductModel for cart
  ProductModel toProductModel() {
    return ProductModel(
      id: id,
      name: name,
      description: description,
      price: price,
      shopId: shopId,
      shopName: shopName,
      imageUrls: imageUrls,
      category: category,
      isAvailable: isAvailable,
      stock: 100,
      createdAt: DateTime.now(),
    );
  }
}

// Keep the old model for backward compatibility
class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String shopId;
  final String shopName;
  final List<String> imageUrls;
  final String category;
  final bool isAvailable;
  final int stock;
  final DateTime createdAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.shopId,
    required this.shopName,
    required this.imageUrls,
    required this.category,
    required this.isAvailable,
    required this.stock,
    required this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] ?? 0.0).toDouble(),
      shopId: json['shopId'],
      shopName: json['shopName'] ?? '',
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      category: json['category'] ?? 'General',
      isAvailable: json['isAvailable'] ?? true,
      stock: json['stock'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'shopId': shopId,
      'shopName': shopName,
      'imageUrls': imageUrls,
      'category': category,
      'isAvailable': isAvailable,
      'stock': stock,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}