import 'package:flutter_admin_dashboard/common/error_handeler.dart';
import 'package:flutter_admin_dashboard/common/typedef.dart';
import 'package:flutter_admin_dashboard/features/category_products/data/models/category_products_model.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/category_products_repo.dart';
import '../data_sources/category_products_remote_data_source.dart';

@LazySingleton(as: CategoryProductsRepo)
class CategoryProductsRepoImpl with HandlingException implements CategoryProductsRepo {

  final CategoryProductsRemoteDataSource categoryProductsRemoteDataSource;

  CategoryProductsRepoImpl({required this.categoryProductsRemoteDataSource});

  @override
  DataResponse<CategoryProductsModel> fetchCategoryProducts(int id) {
    return wrapHandlingException(tryCall: () => categoryProductsRemoteDataSource.fetchCategoryProducts(id));
  }
}