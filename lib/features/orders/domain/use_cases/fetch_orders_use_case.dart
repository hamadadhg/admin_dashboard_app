import 'package:flutter_admin_dashboard/common/typedef.dart';
import 'package:flutter_admin_dashboard/features/orders/data/models/orders_model.dart';
import 'package:flutter_admin_dashboard/features/orders/domain/repositories/orders_repo.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FetchOrdersUseCase implements UseCase<OrdersModel, String> {

  final OrdersRepo ordersRepo;

  FetchOrdersUseCase({required this.ordersRepo});

  @override
  DataResponse<OrdersModel> call(String params) {
    return ordersRepo.fetchOrders(params);
  }
}