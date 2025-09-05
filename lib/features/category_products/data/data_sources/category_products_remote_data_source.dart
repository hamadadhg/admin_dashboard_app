import 'package:flutter_admin_dashboard/common/api_handler.dart';
import 'package:flutter_admin_dashboard/common/dio_helper.dart';
import 'package:flutter_admin_dashboard/features/category_products/data/models/category_products_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CategoryProductsRemoteDataSource with HandlingApiManager {
  
  final DioNetwork dioNetwork;

  CategoryProductsRemoteDataSource({required this.dioNetwork});
  
  Future<CategoryProductsModel> fetchCategoryProducts(int id) {
    return wrapHandlingApi(tryCall: () => dioNetwork.getData(endPoint: '/admin/product/$id'), jsonConvert: categoryProductsModelFromJson);
  }
  
}