import 'dart:async';

import 'package:flutter_admin_dashboard/features/category_products/data/models/category_products_model.dart';
import 'package:flutter_admin_dashboard/features/category_products/domain/use_cases/add_update_product_use_case.dart';
import 'package:flutter_admin_dashboard/features/category_products/domain/use_cases/fetch_category_products_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'category_products_event.dart';

part 'category_products_state.dart';

@injectable
class CategoryProductsBloc extends Bloc<CategoryProductsEvent, CategoryProductsState> {
  final FetchCategoryProductsUseCase fetchCategoryProductsUseCase;
  final AddUpdateProductUseCase addUpdateProductUseCase;

  CategoryProductsBloc(this.fetchCategoryProductsUseCase, this.addUpdateProductUseCase) : super(CategoryProductsState()) {
    on<FetchCategoryProductsEvent>(_fetchProducts);
    on<AddEditProductEvent>(_addUpdateProduct);
  }

  FutureOr<void> _fetchProducts(FetchCategoryProductsEvent event, Emitter emit) async {
    emit(state.copyWith(fetchCategoryProductsStatus: BLocStatus.loading));
    final res = await fetchCategoryProductsUseCase(event.id);
    res.fold((l) {
      emit(state.copyWith(fetchCategoryProductsStatus: BLocStatus.error, errorMessage: l.message));
    }, (r) {
      emit(state.copyWith(fetchCategoryProductsStatus: BLocStatus.success, fetchCategoryProducts: r));
    });
  }

  FutureOr<void> _addUpdateProduct(AddEditProductEvent event, Emitter emit) async {
    emit(state.copyWith(addUpdateProductStatus: BLocStatus.loading));
    final res = await addUpdateProductUseCase(event.params);
    res.fold((l) {
      emit(state.copyWith(addUpdateProductStatus: BLocStatus.error));
    }, (r) {
      emit(state.copyWith(addUpdateProductStatus: BLocStatus.success));
      add(FetchCategoryProductsEvent(id: event.params.categoryId));
    });
  }
}
