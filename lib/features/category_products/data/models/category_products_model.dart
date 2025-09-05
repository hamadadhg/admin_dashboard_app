CategoryProductsModel categoryProductsModelFromJson(str) => CategoryProductsModel.fromJson(str);

class CategoryProductsModel {
  List<CategoryProducts>? products;

  CategoryProductsModel({this.products});

  factory CategoryProductsModel.fromJson(Map<String, dynamic> json) => CategoryProductsModel(
        products: json['products'] == null ? [] : List<CategoryProducts>.from(json['products'].map((x) => CategoryProducts.fromJson(x))),
      );
}

class CategoryProducts {
  int? id;
  String? image;
  String? name;
  String? price;
  String? details;

  CategoryProducts({
    this.image,
    this.name,
    this.price,
    this.details,
    this.id,
  });

  factory CategoryProducts.fromJson(Map<String, dynamic> json) => CategoryProducts(
        id: json['id'],
        image: json['image'],
        name: json['name'],
        price: json['price'],
        details: json['details'],
      );
}
