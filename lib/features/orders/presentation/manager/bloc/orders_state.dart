part of 'orders_bloc.dart';

class OrdersState {
  String? errorMessage;
  BLocStatus? fetchOrdersStatus;
  OrdersModel? fetchOrders;

  BLocStatus? changeStatus;
  int? index;

  BLocStatus? fetchOrderDetailsStatus;
  OrdersModel? fetchOrderDetails;

  OrdersState({
    this.fetchOrders,
    this.errorMessage,
    this.fetchOrdersStatus,
    this.fetchOrderDetails,
    this.fetchOrderDetailsStatus,
    this.changeStatus,
    this.index,
  });

  OrdersState copyWith({
    String? errorMessage,
    BLocStatus? fetchOrdersStatus,
    OrdersModel? fetchOrders,
    BLocStatus? fetchOrderDetailsStatus,
    OrdersModel? fetchOrderDetails,
    BLocStatus? changeStatus,
    int? index,
  }) =>
      OrdersState(
        errorMessage: errorMessage ?? this.errorMessage,
        fetchOrdersStatus: fetchOrdersStatus ?? this.fetchOrdersStatus,
        fetchOrders: fetchOrders ?? this.fetchOrders,
        fetchOrderDetailsStatus: fetchOrderDetailsStatus ?? this.fetchOrderDetailsStatus,
        fetchOrderDetails: fetchOrderDetails ?? this.fetchOrderDetails,
        changeStatus: changeStatus ?? this.changeStatus,
        index: index ?? this.index,
      );
}
