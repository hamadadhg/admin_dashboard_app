class CategoryModel {
  final int id;
  final String name;
  final String image;
  final String? createdAt;
  final String? updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      image: json["image"] ?? "",
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "image": image,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }
}


