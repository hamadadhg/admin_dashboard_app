import 'package:flutter_admin_dashboard/common/common_model.dart';
import 'package:flutter_admin_dashboard/common/typedef.dart';
import 'package:flutter_admin_dashboard/features/orders/data/models/orders_model.dart';

abstract class OrdersRepo {

  DataResponse<OrdersModel> fetchOrders(String status);
  DataResponse<OrdersModel> fetchOrderDetails(int id);
  DataResponse<CommonModel> changeOrderStatus(int id);

}