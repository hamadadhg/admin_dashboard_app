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
