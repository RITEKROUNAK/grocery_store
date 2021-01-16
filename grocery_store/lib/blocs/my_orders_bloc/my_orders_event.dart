part of 'my_orders_bloc.dart';

@immutable
abstract class MyOrdersEvent {}

class GetAllOrdersEvent extends MyOrdersEvent {
  final String uid;

  GetAllOrdersEvent(this.uid);

  @override
  String toString() => 'GetAllOrdersEvent';
}

class GetCancelledOrdersEvent extends MyOrdersEvent {
  final List<MyOrder> allOrders;

  GetCancelledOrdersEvent(this.allOrders);

  @override
  String toString() => 'GetCancelledOrdersEvent';
}

class GetDeliveredOrdersEvent extends MyOrdersEvent {
  final List<MyOrder> allOrders;

  GetDeliveredOrdersEvent(this.allOrders);

  @override
  String toString() => 'GetDeliveredOrdersEvent';
}

class CancelOrderEvent extends MyOrdersEvent {
  final Map cancelOrderMap;

  CancelOrderEvent(this.cancelOrderMap);

  @override
  String toString() => 'CancelOrderEvent';
}
