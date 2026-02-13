class ShopOwnerModel {
  final String id;
  final String phoneNumber;
  final String? name;
  final String? email;
  final String? shopId;
  final String? shopName;
  final bool isApproved;
  final DateTime createdAt;
  final DateTime updatedAt;

  ShopOwnerModel({
    required this.id,
    required this.phoneNumber,
    this.name,
    this.email,
    this.shopId,
    this.shopName,
    this.isApproved = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ShopOwnerModel.fromJson(Map<String, dynamic> json) {
    return ShopOwnerModel(
      id: json['_id'] ?? json['id'],
      phoneNumber: json['phoneNumber'] ?? '',
      name: json['name'],
      email: json['email'],
      shopId: json['shopId'],
      shopName: json['shopName'],
      isApproved: json['isApproved'] ?? false,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'name': name,
      'email': email,
      'shopId': shopId,
      'shopName': shopName,
      'isApproved': isApproved,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  ShopOwnerModel copyWith({
    String? id,
    String? phoneNumber,
    String? name,
    String? email,
    String? shopId,
    String? shopName,
    bool? isApproved,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ShopOwnerModel(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      email: email ?? this.email,
      shopId: shopId ?? this.shopId,
      shopName: shopName ?? this.shopName,
      isApproved: isApproved ?? this.isApproved,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}