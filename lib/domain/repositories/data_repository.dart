import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../config/app_constants.dart';
import '../../data/models/user_model.dart';
import '../../data/models/category_model.dart';
import '../../data/models/api_response.dart';
import '../../data/providers/api_provider.dart';

class DataRepository {
  final ApiProvider _apiProvider;

  DataRepository(this._apiProvider);

  // Get Users
  Future<ApiResponse<UsersResponse>> getUsers() async {
    try {
      final response = await _apiProvider.get<UsersResponse>(
        AppConstants.getUsersEndpoint,
        fromJson: (json) => UsersResponse.fromJson(json),
      );
      return response;
    } catch (e) {
      return ApiResponse.error(message: 'Failed to fetch users: $e');
    }
  }

  // Add Category (works on Web & Mobile/Desktop)
  Future<ApiResponse<CategoryModel>> addCategory({
    required String name,
    File? imageFile, // mobile/desktop
    Uint8List? imageBytes, // web
  }) async {
    try {
      MultipartFile multipartImage;

      if (kIsWeb) {
        if (imageBytes == null) {
          return ApiResponse.error(message: 'Image is required for Web');
        }
        multipartImage = MultipartFile.fromBytes(
          imageBytes,
          filename: 'image_${DateTime.now().millisecondsSinceEpoch}.png',
        );
      } else {
        if (imageFile == null || !imageFile.existsSync()) {
          return ApiResponse.error(message: 'Image file does not exist for Mobile/Desktop');
        }
        multipartImage = await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        );
      }

      final formData = FormData.fromMap({
        'name': name,
        'image': multipartImage,
      });

      final response = await _apiProvider.postFormData<CategoryModel>(
        AppConstants.addCategoryEndpoint,
        formData: formData,
        fromJson: (json) => CategoryModel.fromJson(json),
      );

      return response;
    } catch (e) {
      return ApiResponse.error(message: 'Failed to add category: $e');
    }
  }
}
