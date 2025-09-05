import 'package:flutter_admin_dashboard/common/typedef.dart';
import 'package:flutter_admin_dashboard/features/category_products/data/models/category_products_model.dart';

abstract class CategoryProductsRepo {

  DataResponse<CategoryProductsModel> fetchCategoryProducts(int id);

}