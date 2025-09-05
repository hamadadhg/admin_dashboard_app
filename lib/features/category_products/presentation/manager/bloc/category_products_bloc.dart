import 'dart:async';

import 'package:flutter_admin_dashboard/features/category_products/data/models/category_products_model.dart';
import 'package:flutter_admin_dashboard/features/category_products/domain/use_cases/fetch_category_products_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'category_products_event.dart';

part 'category_products_state.dart';

@injectable
class CategoryProductsBloc extends Bloc<CategoryProductsEvent, CategoryProductsState> {
  final FetchCategoryProductsUseCase fetchCategoryProductsUseCase;

  CategoryProductsBloc(this.fetchCategoryProductsUseCase) : super(CategoryProductsState()) {
    on<FetchCategoryProductsEvent>(_fetchProducts);
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
}
