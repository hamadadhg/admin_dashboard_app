import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_admin_dashboard/config/app_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';

class CategoryService {
  static const String baseUrl = "https://res.mustafafares.com/api";
  static Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  CategoryService() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.kBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add auth token if available
        String? token = await _storage.read(key: AppConstants.tokenKey);
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        print('API Error: ${error.message}');
        handler.next(error);
      },
    ));
  }
  static Future<bool> deleteCategory(int id) async {
    try {
      final response = await _dio.delete(
        'https://res.mustafafares.com/api/products/$id',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return true;
      } else {
        throw Exception(
            response.data['message'] ?? 'Failed to delete category');
      }
    } catch (e) {
      throw Exception("Delete failed: $e");
    }
  }

  static Future<CategoryModel?> updateCategory({
    required int id,
    required String name,
    required File? imageFile,
  }) async {
    try {
      var uri = Uri.parse("$baseUrl/updateCategory/$id");
      var request = http.MultipartRequest("POST", uri);

      request.fields['name'] = name;

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath("image", imageFile.path),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return CategoryModel.fromJson(data['category']);
      } else {
        throw Exception("Failed to update category: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
