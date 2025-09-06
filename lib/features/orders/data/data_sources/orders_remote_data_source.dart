import 'package:flutter_admin_dashboard/common/api_handler.dart';
import 'package:flutter_admin_dashboard/common/dio_helper.dart';
import 'package:flutter_admin_dashboard/features/orders/data/models/orders_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class OrdersRemoteDataSource with HandlingApiManager {
  final DioNetwork dioNetwork;

  OrdersRemoteDataSource({required this.dioNetwork});

  Future<OrdersModel> fetchOrders(String status) {
    return wrapHandlingApi(
        tryCall: () => dioNetwork.postData(endPoint: '/orders/by-status', data: {"status": status}), jsonConvert: ordersModelFromJson);
  }

  Future<OrdersModel> fetchOrderDetails(int id) {
    return wrapHandlingApi(tryCall: () => dioNetwork.getData(endPoint: '/orders/Details/$id'), jsonConvert: ordersModelFromJson);
  }
}
