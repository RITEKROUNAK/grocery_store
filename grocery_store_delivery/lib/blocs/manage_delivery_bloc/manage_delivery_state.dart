part of 'manage_delivery_bloc.dart';

@immutable
abstract class ManageDeliveryState {}

class ManageDeliveryInitial extends ManageDeliveryState {}

class DeliverOrderInProgressState extends ManageDeliveryState {
  @override
  String toString() => 'DeliverOrderInProgressState';
}

class DeliverOrderFailedState extends ManageDeliveryState {
  @override
  String toString() => 'DeliverOrderFailedState';
}

class DeliverOrderCompletedState extends ManageDeliveryState {
  @override
  String toString() => 'DeliverOrderCompletedState';
}

class CancelOrderInProgressState extends ManageDeliveryState {
  @override
  String toString() => 'CancelOrderInProgressState';
}

class CancelOrderFailedState extends ManageDeliveryState {
  @override
  String toString() => 'CancelOrderFailedState';
}

class CancelOrderCompletedState extends ManageDeliveryState {
  @override
  String toString() => 'CancelOrderCompletedState';
}

class GetAllAssignedOrdersInProgressState extends ManageDeliveryState {
  @override
  String toString() => 'GetAllAssignedOrdersInProgressState';
}

class GetAllAssignedOrdersFailedState extends ManageDeliveryState {
  @override
  String toString() => 'GetAllAssignedOrdersFailedState';
}

class GetAllAssignedOrdersCompletedState extends ManageDeliveryState {
  final List<Order> allOrders;

  GetAllAssignedOrdersCompletedState(this.allOrders);
  @override
  String toString() => 'GetAllAssignedOrdersCompletedState';
}

class GetCompletedOrdersInProgressState extends ManageDeliveryState {
  @override
  String toString() => 'GetCompletedOrdersInProgressState';
}

class GetCompletedOrdersFailedState extends ManageDeliveryState {
  @override
  String toString() => 'GetCompletedOrdersFailedState';
}

class GetCompletedOrdersCompletedState extends ManageDeliveryState {
  final List<Order> completedOrders;

  GetCompletedOrdersCompletedState(this.completedOrders);
  @override
  String toString() => 'GetCompletedOrdersCompletedState';
}
