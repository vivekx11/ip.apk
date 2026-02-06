class ShopOwnerModel {
  final String id;
  final String phoneNumber;
  final String? name;
  final String? email;
  final String? shopId;
  final String? shopName;
  final bool isApproved;
  final DateTime createdAt;

  ShopOwnerModel({
    required this.id,
    required this.phoneNumber,
    this.name,
    this.email,
    this.shopId,
    this.shopName,
    required this.isApproved,
    required this.createdAt,
  });

  factory ShopOwnerModel.fromJson(Map<String, dynamic> json) {
    return ShopOwnerModel(
      id: json['_id'] ?? json['id'],
      phoneNumber: json['phoneNumber'],
      name: json['name'],
      email: json['email'],
      shopId: json['shopId'],
      shopName: json['shopName'],
      isApproved: json['isApproved'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
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
    };
  }
}