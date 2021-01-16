part of 'orders_bloc.dart';

@immutable
abstract class OrdersEvent {}

class GetAllOrdersEvent extends OrdersEvent {
  @override
  String toString() => 'GetAllOrdersEvent';
}

class GetDeliveredOrdersEvent extends OrdersEvent {
  @override
  String toString() => 'GetDeliveredOrdersEvent';
}

class GetNewOrdersEvent extends OrdersEvent {
  @override
  String toString() => 'GetNewOrdersEvent';
}

class GetProcessedOrdersEvent extends OrdersEvent {
  @override
  String toString() => 'GetProcessedOrdersEvent';
}

class GetOutForDeliveryOrdersEvent extends OrdersEvent {
  @override
  String toString() => 'GetOutForDeliveryOrdersEvent';
}

class GetCancelledOrdersEvent extends OrdersEvent {
  @override
  String toString() => 'GetCancelledOrdersEvent';
}

class GetPendingRefundOrdersEvent extends OrdersEvent {
  @override
  String toString() => 'GetPendingRefundOrdersEvent';
}

class GetAllOrdersValuesEvent extends OrdersEvent {
  final List<Order> allOrders;

  GetAllOrdersValuesEvent(this.allOrders);
  @override
  String toString() => 'GetAllOrdersValuesEvent';
}

class LoadNewOrdersEvent extends OrdersEvent {
  @override
  String toString() => 'LoadNewOrdersEvent';
}

class UpdateNewOrdersEvent extends OrdersEvent {
  final List<Order> newOrders;

  UpdateNewOrdersEvent(this.newOrders);

  @override
  String toString() => 'UpdateNewOrdersEvent';
}

class GetOrderAnalyticsEvent extends OrdersEvent {
  @override
  String toString() => 'GetOrderAnalyticsEvent';
}

class UpdateOrderAnalyticsEvent extends OrdersEvent {
  final OrderAnalytics orderAnalytics;

  UpdateOrderAnalyticsEvent(this.orderAnalytics);

  @override
  String toString() => 'GetOrderAnalyticsEvent';
}

class ProceedOrderEvent extends OrdersEvent {
  final Map proceedOrderMap;

  ProceedOrderEvent(this.proceedOrderMap);
  @override
  String toString() => 'ProceedOrderEvent';
}

class CancelOrderEvent extends OrdersEvent {
  final Map cancelOrderMap;

  CancelOrderEvent(this.cancelOrderMap);
  @override
  String toString() => 'CancelOrderEvent';
}

class InitiateRefundEvent extends OrdersEvent {
  final Map initiateRefundMap;

  InitiateRefundEvent(this.initiateRefundMap);
  @override
  String toString() => 'InitiateRefundEvent';
}
