import 'dart:io';

import 'package:flutter_admin_dashboard/common/common_model.dart';
import 'package:flutter_admin_dashboard/common/typedef.dart';
import 'package:injectable/injectable.dart';

import '../repositories/category_products_repo.dart';

@lazySingleton
class AddUpdateProductUseCase implements UseCase<CommonModel, AddUpdateProductParams> {
  final CategoryProductsRepo categoryProductsRepo;

  AddUpdateProductUseCase({required this.categoryProductsRepo});

  @override
  DataResponse<CommonModel> call(AddUpdateProductParams params) {
    return categoryProductsRepo.addUpdateProduct(params);
  }
}

class AddUpdateProductParams with Params {
  final bool isUpdate;

  final String name;
  final String price;
  final String details;
  final File? image;
  final int categoryId;

  AddUpdateProductParams(
      {this.isUpdate = false, required this.name, required this.price, required this.details, required this.image, required this.categoryId});

  @override
  BodyMap getBody() => {
        'name': name,
        'price': price,
        'detaile': details,
        'category_id': categoryId,
        'image': image,
      };
}
