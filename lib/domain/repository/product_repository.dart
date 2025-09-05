import 'dart:io';
import 'package:dio/dio.dart';
import '../../data/models/product_model.dart';
import '../../data/providers/api_provider.dart';
import '../../data/models/api_response.dart';

class ProductRepository {
  final ApiProvider apiProvider;

  ProductRepository(this.apiProvider);

  Future<ApiResponse<ProductModel>> addProduct(String name, String price, String details, int categoryId, File image) async {
    String fileName = image.path.split('/').last;
    FormData formData = FormData.fromMap({
      "name": name,
      "price": price,
      "details": details,
      "category_id": categoryId,
      "image": await MultipartFile.fromFile(image.path, filename: fileName),
    });
    final response = await apiProvider.postFormData(
      '/addProduct',
      formData: formData,
      fromJson: (json) => ProductModel.fromJson(json['product']),
    );
    return response;
  }

  Future<ApiResponse<Map<String, dynamic>>> deleteProduct(int id) async {
    final response = await apiProvider.delete(
      '/products/$id',
    );
    return ApiResponse.success(data: response.data);
  }

  Future<ApiResponse<List<ProductModel>>> getProductsByCategory(int categoryId) async {
    final response = await apiProvider.get(
      '/admin/product/$categoryId',
      fromJson: (json) => (json['products'] as List).map((i) => ProductModel.fromJson(i)).toList(),
    );
    return response;
  }
}


