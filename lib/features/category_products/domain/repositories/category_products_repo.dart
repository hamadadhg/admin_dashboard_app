import 'package:flutter_admin_dashboard/common/common_model.dart';
import 'package:flutter_admin_dashboard/common/typedef.dart';
import 'package:flutter_admin_dashboard/features/category_products/data/models/category_products_model.dart';
import 'package:flutter_admin_dashboard/features/category_products/domain/use_cases/add_update_product_use_case.dart';

abstract class CategoryProductsRepo {

  DataResponse<CategoryProductsModel> fetchCategoryProducts(int id);
  DataResponse<CommonModel> addUpdateProduct(AddUpdateProductParams params);

}