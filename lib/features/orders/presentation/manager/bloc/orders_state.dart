part of 'orders_bloc.dart';

class OrdersState {
  String? errorMessage;
  BLocStatus? fetchOrdersStatus;
  OrdersModel? fetchOrders;

  BLocStatus? fetchOrderDetailsStatus;
  OrdersModel? fetchOrderDetails;

  OrdersState({
    this.fetchOrders,
    this.errorMessage,
    this.fetchOrdersStatus,
    this.fetchOrderDetails,
    this.fetchOrderDetailsStatus,
  });

  OrdersState copyWith({
    String? errorMessage,
    BLocStatus? fetchOrdersStatus,
    OrdersModel? fetchOrders,
    BLocStatus? fetchOrderDetailsStatus,
    OrdersModel? fetchOrderDetails,
  }) =>
      OrdersState(
        errorMessage: errorMessage ?? this.errorMessage,
        fetchOrdersStatus: fetchOrdersStatus ?? this.fetchOrdersStatus,
        fetchOrders: fetchOrders ?? this.fetchOrders,
        fetchOrderDetailsStatus: fetchOrderDetailsStatus ?? this.fetchOrderDetailsStatus,
        fetchOrderDetails: fetchOrderDetails ?? this.fetchOrderDetails,
      );
}
