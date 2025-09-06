part of 'orders_bloc.dart';

abstract class OrdersEvent {}

class FetchOrdersEvent extends OrdersEvent {
  final String status;

  FetchOrdersEvent({required this.status});
}

class FetchOrderDetailsEvent extends OrdersEvent {
  final int id;

  FetchOrderDetailsEvent({required this.id});
}

class ChangeOrderStatus extends OrdersEvent {
  final int id;
  final int index;
  final BuildContext context;

  ChangeOrderStatus(this.context, {required this.id, required this.index});
}
