part of 'category_products_bloc.dart';

abstract class CategoryProductsEvent {}

class FetchCategoryProductsEvent extends CategoryProductsEvent {
  final int id;

  FetchCategoryProductsEvent({required this.id});
}

class AddEditProductEvent extends CategoryProductsEvent {
  final AddUpdateProductParams params;

  AddEditProductEvent({required this.params});
}
