import 'package:flutter_admin_dashboard/common/error_handeler.dart';
import 'package:flutter_admin_dashboard/common/typedef.dart';
import 'package:flutter_admin_dashboard/features/orders/data/models/orders_model.dart';
import 'package:flutter_admin_dashboard/features/orders/domain/repositories/orders_repo.dart';
import 'package:injectable/injectable.dart';

import '../data_sources/orders_remote_data_source.dart';

@LazySingleton(as: OrdersRepo)
class OrdersRepoImpl with HandlingException implements OrdersRepo {
  final OrdersRemoteDataSource ordersRemoteDataSource;

  OrdersRepoImpl({required this.ordersRemoteDataSource});

  @override
  DataResponse<OrdersModel> fetchOrders(String status) {
    return wrapHandlingException(tryCall: () => ordersRemoteDataSource.fetchOrders(status));
  }

  @override
  DataResponse<OrdersModel> fetchOrderDetails(int id) {
    return wrapHandlingException(tryCall: () => ordersRemoteDataSource.fetchOrderDetails(id));
  }
}
