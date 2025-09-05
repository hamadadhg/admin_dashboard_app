import 'package:flutter_admin_dashboard/common/typedef.dart';
import 'package:flutter_admin_dashboard/features/category_products/data/models/category_products_model.dart';
import 'package:flutter_admin_dashboard/features/category_products/domain/repositories/category_products_repo.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FetchCategoryProductsUseCase implements UseCase<CategoryProductsModel, int> {
  final CategoryProductsRepo categoryProductsRepo;

  FetchCategoryProductsUseCase({required this.categoryProductsRepo});

  @override
  DataResponse<CategoryProductsModel> call(int params) {
    return categoryProductsRepo.fetchCategoryProducts(params);
  }
}
