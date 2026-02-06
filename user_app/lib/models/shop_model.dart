class Shop {
  final String id;
  final String name;
  final String description;
  final String category;
  final double rating;
  final String address;
  final String phone;
  final bool isOpen;
  final String imageUrl;

  Shop({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.rating,
    required this.address,
    required this.phone,
    required this.isOpen,
    required this.imageUrl,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      address: json['address'],
      phone: json['phone'],
      isOpen: json['isOpen'] ?? true,
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'rating': rating,
      'address': address,
      'phone': phone,
      'isOpen': isOpen,
      'imageUrl': imageUrl,
    };
  }
}

// Keep the old model for backward compatibility
class ShopModel {
  final String id;
  final String name;
  final String description;
  final String ownerPhone;
  final String? address;
  final String? imageUrl;
  final bool isActive;
  final bool isApproved;
  final double rating;
  final int totalOrders;
  final DateTime createdAt;

  ShopModel({
    required this.id,
    required this.name,
    required this.description,
    required this.ownerPhone,
    this.address,
    this.imageUrl,
    required this.isActive,
    required this.isApproved,
    required this.rating,
    required this.totalOrders,
    required this.createdAt,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      description: json['description'],
      ownerPhone: json['ownerPhone'],
      address: json['address'],
      imageUrl: json['imageUrl'],
      isActive: json['isActive'] ?? true,
      isApproved: json['isApproved'] ?? false,
      rating: (json['rating'] ?? 0.0).toDouble(),
      totalOrders: json['totalOrders'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'ownerPhone': ownerPhone,
      'address': address,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'isApproved': isApproved,
      'rating': rating,
      'totalOrders': totalOrders,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}