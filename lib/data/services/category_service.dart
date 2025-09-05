import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';

class CategoryService {
  static const String baseUrl = "https://res.mustafafares.com/api";
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
