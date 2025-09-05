import 'dart:io';
import '../../data/models/product_model.dart';
import '../../data/models/api_response.dart';
import '../repository/product_repository.dart';

class ProductUseCase {
  final ProductRepository productRepository;

  ProductUseCase(this.productRepository);

  Future<ApiResponse<ProductModel>> addProduct(String name, String price, String details, int categoryId, File image) {
    return productRepository.addProduct(name, price, details, categoryId, image);
  }

  Future<ApiResponse<Map<String, dynamic>>> deleteProduct(int id) {
    return productRepository.deleteProduct(id);
  }

  Future<ApiResponse<List<ProductModel>>> getProductsByCategory(int categoryId) {
    return productRepository.getProductsByCategory(categoryId);
  }
}


