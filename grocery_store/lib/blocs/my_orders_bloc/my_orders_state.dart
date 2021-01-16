part of 'my_orders_bloc.dart';

@immutable
abstract class MyOrdersState {}

class MyOrdersInitial extends MyOrdersState {}

class GetAllOrdersInProgressState extends MyOrdersState {
  @override
  String toString() => 'GetAllOrdersInProgressState';
}

class GetAllOrdersFailedState extends MyOrdersState {
  @override
  String toString() => 'GetAllOrdersFailedState';
}

class GetAllOrdersCompletedState extends MyOrdersState {
  final List<MyOrder> allOrders;

  GetAllOrdersCompletedState(this.allOrders);

  @override
  String toString() => 'GetAllOrdersCompletedState';
}

class GetCancelledOrdersInProgressState extends MyOrdersState {
  @override
  String toString() => 'GetCancelledOrdersInProgressState';
}

class GetCancelledOrdersFailedState extends MyOrdersState {
  @override
  String toString() => 'GetCancelledOrdersFailedState';
}

class GetCancelledOrdersCompletedState extends MyOrdersState {
  final List<MyOrder> cancelledOrders;

  GetCancelledOrdersCompletedState(this.cancelledOrders);

  @override
  String toString() => 'GetCancelledOrdersCompletedState';
}

class GetDeliveredOrdersInProgressState extends MyOrdersState {
  @override
  String toString() => 'GetDeliveredOrdersInProgressState';
}

class GetDeliveredOrdersFailedState extends MyOrdersState {
  @override
  String toString() => 'GetDeliveredOrdersFailedState';
}

class GetDeliveredOrdersCompletedState extends MyOrdersState {
  final List<MyOrder> deliveredOrders;

  GetDeliveredOrdersCompletedState(this.deliveredOrders);

  @override
  String toString() => 'GetDeliveredOrdersCompletedState';
}

class CancelOrderInProgressState extends MyOrdersState {
  @override
  String toString() => 'CancelOrderInProgressState';
}

class CancelOrderFailedState extends MyOrdersState {
  @override
  String toString() => 'CancelOrderFailedState';
}

class CancelOrderCompletedState extends MyOrdersState {
  @override
  String toString() => 'CancelOrderCompletedState';
}
