import 'dart:io';
import 'dart:typed_data';
import '../../data/models/category_model.dart';
import '../../data/models/api_response.dart';
import '../repository/category_repository.dart';

class CategoryUseCase {
  final CategoryRepository categoryRepository;

  CategoryUseCase(this.categoryRepository);

  Future<ApiResponse<CategoryModel>> addCategory(String name, Uint8List image) {
    return categoryRepository.addCategory(name, image);
  }

  Future<ApiResponse<CategoryModel>> updateCategory(int id, String name, {File? image}) {
    return categoryRepository.updateCategory(id, name, image: image);
  }

  Future<ApiResponse<List<CategoryModel>>> getCategories() {
    return categoryRepository.getCategories();
  }
}


