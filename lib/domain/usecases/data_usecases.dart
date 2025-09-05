import 'dart:io';
import 'dart:typed_data';
import '../repositories/data_repository.dart';
import '../../data/models/user_model.dart';
import '../../data/models/category_model.dart';
import '../../data/models/api_response.dart';
import 'package:flutter/foundation.dart';

class DataUseCases {
  final DataRepository _dataRepository;

  DataUseCases(this._dataRepository);

  // Get users use case
  Future<ApiResponse<UsersResponse>> fetchUsers() async {
    return await _dataRepository.getUsers();
  }

  // Add category use case (supports Web and Mobile/Desktop)
  Future<ApiResponse<CategoryModel>> createCategory({
    required String name,
    File? imageFile, // For mobile/desktop
    Uint8List? imageBytes, // For Web
  }) async {
    // Validate input
    if (name.isEmpty) {
      return ApiResponse.error(message: 'Category name is required');
    }
    if (name.length < 2) {
      return ApiResponse.error(
          message: 'Category name must be at least 2 characters');
    }

    // Validate image
    if (kIsWeb) {
      if (imageBytes == null || imageBytes.isEmpty) {
        return ApiResponse.error(message: 'Image is required');
      }
    } else {
      if (imageFile == null || !imageFile.existsSync()) {
        return ApiResponse.error(message: 'Selected image file does not exist');
      }

      // Check file size (limit to 5MB)
      final fileSizeInBytes = imageFile.lengthSync();
      final fileSizeInMB = fileSizeInBytes / (1024 * 1024);
      if (fileSizeInMB > 5) {
        return ApiResponse.error(
            message: 'Image file size must be less than 5MB');
      }

      // Check file extension
      final allowedExtensions = ['jpg', 'jpeg', 'png', 'gif'];
      final fileExtension = imageFile.path.split('.').last.toLowerCase();
      if (!allowedExtensions.contains(fileExtension)) {
        return ApiResponse.error(
          message: 'Only JPG, JPEG, PNG, and GIF files are allowed',
        );
      }
    }

    return await _dataRepository.addCategory(
      name: name,
      imageFile: imageFile,
      imageBytes: imageBytes,
    );
  }
}
