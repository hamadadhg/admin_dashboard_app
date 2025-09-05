import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import '../../data/models/category_model.dart';
import '../../data/providers/api_provider.dart';
import '../../data/models/api_response.dart';

class CategoryRepository {
  final ApiProvider apiProvider;

  CategoryRepository(this.apiProvider);

  Future<ApiResponse<CategoryModel>> addCategory(String name, Uint8List image) async {
    FormData formData = FormData.fromMap({
      "name": name,
      "image": MultipartFile.fromBytes(
        image,
        filename: "category.png",
        contentType: MediaType("image", "png"), // set actual MIME type
      ),
    });

    final response = await apiProvider.postFormData(
      '/addCategory',
      formData: formData,
      fromJson: (json) => CategoryModel.fromJson(json['category']),
    );

    return response;
  }

  Future<ApiResponse<CategoryModel>> updateCategory(int id, String name, {File? image}) async {
    FormData formData = FormData.fromMap({
      "name": name,
    });
    if (image != null) {
      String fileName = image.path.split('/').last;
      formData.files.add(MapEntry("image", await MultipartFile.fromFile(image.path, filename: fileName)));
    }
    final response = await apiProvider.postFormData(
      '/updateCategory/$id',
      formData: formData,
      fromJson: (json) => CategoryModel.fromJson(json['category']),
    );
    return response;
  }

  Future<ApiResponse<List<CategoryModel>>> getCategories() async {
    final response = await apiProvider.get(
      '/admin/category',
      fromJson: (json) => (json['categories'] as List).map((i) => CategoryModel.fromJson(i)).toList(),
    );
    return response;
  }
}


