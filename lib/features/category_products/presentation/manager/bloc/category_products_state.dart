part of 'category_products_bloc.dart';

enum BLocStatus { init, loading, success, error }

class CategoryProductsState {
  String? errorMessage;
  BLocStatus? fetchCategoryProductsStatus;
  BLocStatus? addUpdateProductStatus;
  CategoryProductsModel? fetchCategoryProducts;

  CategoryProductsState({
    this.fetchCategoryProducts,
    this.errorMessage,
    this.addUpdateProductStatus,
    this.fetchCategoryProductsStatus,
  });

  CategoryProductsState copyWith({
    String? errorMessage,
    BLocStatus? fetchCategoryProductsStatus,
    BLocStatus? addUpdateProductStatus,
    CategoryProductsModel? fetchCategoryProducts,
  }) =>
      CategoryProductsState(
        errorMessage: errorMessage ?? this.errorMessage,
        fetchCategoryProductsStatus: fetchCategoryProductsStatus ?? this.fetchCategoryProductsStatus,
        fetchCategoryProducts: fetchCategoryProducts ?? this.fetchCategoryProducts,
        addUpdateProductStatus: addUpdateProductStatus ?? this.addUpdateProductStatus,
      );
}
