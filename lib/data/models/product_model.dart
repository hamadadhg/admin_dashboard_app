class ProductModel {
  final int id;
  final String name;
  final String price;
  final String details;
  final String image;
  final int categoryId;
  final String? createdAt;
  final String? updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.details,
    required this.image,
    required this.categoryId,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      price: json["price"] ?? "",
      details: json["details"] ?? "",
      image: json["image"] ?? "",
      categoryId: json["category_id"] ?? 0,
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "price": price,
      "details": details,
      "image": image,
      "category_id": categoryId,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }
}


