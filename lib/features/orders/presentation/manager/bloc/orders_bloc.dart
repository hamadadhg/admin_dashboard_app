import 'dart:async';

import 'package:flutter_admin_dashboard/features/category_products/presentation/manager/bloc/category_products_bloc.dart';
import 'package:flutter_admin_dashboard/features/orders/data/models/orders_model.dart';
import 'package:flutter_admin_dashboard/features/orders/domain/use_cases/fetch_order_details_use_case.dart';
import 'package:flutter_admin_dashboard/features/orders/domain/use_cases/fetch_orders_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'orders_event.dart';

part 'orders_state.dart';

@injectable
class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final FetchOrdersUseCase fetchOrdersUseCase;
  final FetchOrderDetailsUseCase fetchOrderDetailsUseCase;

  OrdersBloc(this.fetchOrdersUseCase, this.fetchOrderDetailsUseCase) : super(OrdersState()) {
    on<FetchOrdersEvent>(_fetchOrders);
    on<FetchOrderDetailsEvent>(_fetchOrderDetails);
  }

  FutureOr<void> _fetchOrders(FetchOrdersEvent event, Emitter emit) async {
    emit(state.copyWith(fetchOrdersStatus: BLocStatus.loading));
    final res = await fetchOrdersUseCase(event.status);
    res.fold((l) {
      emit(state.copyWith(fetchOrdersStatus: BLocStatus.error, errorMessage: l.message));
    }, (r) {
      emit(state.copyWith(fetchOrdersStatus: BLocStatus.success, fetchOrders: r));
    });
  }

  FutureOr<void> _fetchOrderDetails(FetchOrderDetailsEvent event, Emitter emit) async {
    emit(state.copyWith(fetchOrderDetailsStatus: BLocStatus.loading));
    final res = await fetchOrderDetailsUseCase(event.id);
    res.fold((l) {
      emit(state.copyWith(fetchOrderDetailsStatus: BLocStatus.error, errorMessage: l.message));
    }, (r) {
      emit(state.copyWith(fetchOrderDetailsStatus: BLocStatus.success, fetchOrderDetails: r));
    });
  }
}
