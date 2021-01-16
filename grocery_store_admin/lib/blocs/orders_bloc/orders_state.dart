part of 'orders_bloc.dart';

@immutable
abstract class OrdersState {}

class OrdersInitialState extends OrdersState {
  @override
  String toString() => 'OrdersInitialState';
}

class NewOrdersInitialState extends OrdersState {
  @override
  String toString() => 'NewOrdersInitialState';
}

class ManageOrderInitialState extends OrdersState {
  @override
  String toString() => 'ManageOrderInitialState';
}

class ProcessedOrdersInitialState extends OrdersState {
  @override
  String toString() => 'ProcessedOrdersInitialState';
}

class OutForDeliveryOrdersInitialState extends OrdersState {
  @override
  String toString() => 'OutForDeliveryOrdersInitialState';
}

class ProceedOrderInitialState extends OrdersState {
  @override
  String toString() => 'ProceedOrderInitialState';
}

class DeliveredOrdersInitialState extends OrdersState {
  @override
  String toString() => 'DeliveredOrdersInitialState';
}

class CancelledOrdersInitialState extends OrdersState {
  @override
  String toString() => 'CancelledOrdersInitialState';
}

class GetAllOrdersCompletedState extends OrdersState {
  final List<Order> allOrders;
  GetAllOrdersCompletedState(this.allOrders);

  String toString() => 'GetAllOrdersCompletedState';
}

class GetAllOrdersFailedState extends OrdersState {
  String toString() => 'GetAllOrdersFailedState';
}

class GetAllOrdersInProgressState extends OrdersState {
  String toString() => 'GetAllOrdersInProgressState';
}

class GetNewOrdersCompletedState extends OrdersState {
  final List<Order> newOrders;
  GetNewOrdersCompletedState(this.newOrders);

  String toString() => 'GetNewOrdersCompletedState';
}

class GetNewOrdersFailedState extends OrdersState {
  String toString() => 'GetNewOrdersFailedState';
}

class GetNewOrdersInProgressState extends OrdersState {
  String toString() => 'GetNewOrdersInProgressState';
}

class GetProcessedOrdersCompletedState extends OrdersState {
  final List<Order> processedOrders;
  GetProcessedOrdersCompletedState(this.processedOrders);

  String toString() => 'GetProcessedOrdersCompletedState';
}

class GetProcessedOrdersFailedState extends OrdersState {
  String toString() => 'GetProcessedOrdersFailedState';
}

class GetProcessedOrdersInProgressState extends OrdersState {
  String toString() => 'GetProcessedOrdersInProgressState';
}

class GetOutForDeliveryOrdersCompletedState extends OrdersState {
  final List<Order> outForDeliveryOrders;
  GetOutForDeliveryOrdersCompletedState(this.outForDeliveryOrders);

  String toString() => 'GetOutForDeliveryOrdersCompletedState';
}

class GetOutForDeliveryOrdersFailedState extends OrdersState {
  String toString() => 'GetOutForDeliveryOrdersFailedState';
}

class GetOutForDeliveryOrdersInProgressState extends OrdersState {
  String toString() => 'GetOutForDeliveryOrdersInProgressState';
}

class GetCancelledOrdersCompletedState extends OrdersState {
  final List<Order> cancelledOrders;
  GetCancelledOrdersCompletedState(this.cancelledOrders);

  String toString() => 'GetCancelledOrdersCompletedState';
}

class GetCancelledOrdersFailedState extends OrdersState {
  String toString() => 'GetCancelledOrdersFailedState';
}

class GetCancelledOrdersInProgressState extends OrdersState {
  String toString() => 'GetCancelledOrdersInProgressState';
}

class GetPendingRefundOrdersCompletedState extends OrdersState {
  final List<Order> pendingRefundOrders;
  GetPendingRefundOrdersCompletedState(this.pendingRefundOrders);

  String toString() => 'GetPendingRefundOrdersCompletedState';
}

class GetPendingRefundOrdersFailedState extends OrdersState {
  String toString() => 'GetPendingRefundOrdersFailedState';
}

class GetPendingRefundOrdersInProgressState extends OrdersState {
  String toString() => 'GetPendingRefundOrdersInProgressState';
}

class GetDeliveredOrdersCompletedState extends OrdersState {
  final List<Order> deliveredOrders;
  GetDeliveredOrdersCompletedState(this.deliveredOrders);

  String toString() => 'GetDeliveredOrdersCompletedState';
}

class GetDeliveredOrdersFailedState extends OrdersState {
  String toString() => 'GetDeliveredOrdersFailedState';
}

class GetDeliveredOrdersInProgressState extends OrdersState {
  String toString() => 'GetDeliveredOrdersInProgressState';
}

class GetAllOrdersValuesCompletedState extends OrdersState {
  final List<Order> allOrders;
  final List<Order> deliveredOrders;
  final List<Order> cancelledOrders;
  final List<Order> newOrders;

  GetAllOrdersValuesCompletedState({
    @required this.allOrders,
    @required this.deliveredOrders,
    @required this.cancelledOrders,
    @required this.newOrders,
  });

  String toString() => 'GetAllOrdersValuesCompletedState';
}

class GetAllOrdersValuesFailedState extends OrdersState {
  String toString() => 'GetAllOrdersValuesFailedState';
}

class GetAllOrdersValuesInProgressState extends OrdersState {
  String toString() => 'GetAllOrdersValuesInProgressState';
}

class LoadNewOrdersCompletedState extends OrdersState {
  final List<Order> newOrders;

  LoadNewOrdersCompletedState({
    @required this.newOrders,
  });

  String toString() => 'LoadNewOrdersCompletedState';
}

class LoadNewOrdersFailedState extends OrdersState {
  String toString() => 'LoadNewOrdersFailedState';
}

class LoadNewOrdersInProgressState extends OrdersState {
  String toString() => 'LoadNewOrdersInProgressState';
}

class UpdateNewOrdersCompletedState extends OrdersState {
  final List<Order> newOrders;

  UpdateNewOrdersCompletedState({
    @required this.newOrders,
  });

  String toString() => 'UpdateNewOrdersCompletedState';
}

class UpdateNewOrdersFailedState extends OrdersState {
  String toString() => 'UpdateNewOrdersFailedState';
}

class UpdateNewOrdersInProgressState extends OrdersState {
  String toString() => 'UpdateNewOrdersInProgressState';
}

class GetOrderAnalyticsCompletedState extends OrdersState {
  final OrderAnalytics orderAnalytics;

  GetOrderAnalyticsCompletedState({
    @required this.orderAnalytics,
  });

  String toString() => 'GetOrderAnalyticsCompletedState';
}

class GetOrderAnalyticsFailedState extends OrdersState {
  String toString() => 'GetOrderAnalyticsFailedState';
}

class GetOrderAnalyticsInProgressState extends OrdersState {
  String toString() => 'GetOrderAnalyticsInProgressState';
}

class UpdateOrderAnalyticsState extends OrdersState {
  final OrderAnalytics orderAnalytics;

  UpdateOrderAnalyticsState(this.orderAnalytics);

  String toString() => 'UpdateOrderAnalyticsState';
}

class ProceedOrderCompletedState extends OrdersState {
  String toString() => 'ProceedOrderCompletedState';
}

class ProceedOrderFailedState extends OrdersState {
  String toString() => 'ProceedOrderFailedState';
}

class ProceedOrderInProgressState extends OrdersState {
  String toString() => 'ProceedOrderInProgressState';
}

class CancelOrderCompletedState extends OrdersState {
  String toString() => 'CancelOrderCompletedState';
}

class CancelOrderFailedState extends OrdersState {
  String toString() => 'CancelOrderFailedState';
}

class CancelOrderInProgressState extends OrdersState {
  String toString() => 'CancelOrderInProgressState';
}

class InitiateRefundCompletedState extends OrdersState {
  String toString() => 'InitiateRefundCompletedState';
}

class InitiateRefundFailedState extends OrdersState {
  String toString() => 'InitiateRefundFailedState';
}

class InitiateRefundInProgressState extends OrdersState {
  String toString() => 'InitiateRefundInProgressState';
}
