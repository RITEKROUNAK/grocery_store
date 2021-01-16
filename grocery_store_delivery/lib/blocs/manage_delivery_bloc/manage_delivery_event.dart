part of 'manage_delivery_bloc.dart';

@immutable
abstract class ManageDeliveryEvent {}

class DeliverOrderEvent extends ManageDeliveryEvent {
  final Map deliverOrderMap;

  DeliverOrderEvent(this.deliverOrderMap);
  @override
  String toString() => 'DeliverOrderEvent';
}

class CancelOrderEvent extends ManageDeliveryEvent {
  final Map cancelOrderMap;

  CancelOrderEvent(this.cancelOrderMap);
  @override
  String toString() => 'CancelOrderEvent';
}

class GetAllAssignedOrdersEvent extends ManageDeliveryEvent {
  final String uid;

  GetAllAssignedOrdersEvent(this.uid);
  @override
  String toString() => 'GetAllAssignedOrdersEvent';
}

class UpdateAllAssignedOrdersEvent extends ManageDeliveryEvent {
  final List<Order> orders;

  UpdateAllAssignedOrdersEvent(this.orders);
  @override
  String toString() => 'UpdateAllAssignedOrdersEvent';
}

class GetCompletedOrdersEvent extends ManageDeliveryEvent {
  final String uid;

  GetCompletedOrdersEvent(this.uid);
  @override
  String toString() => 'GetCompletedOrdersEvent';
}

class UpdateCompletedOrdersEvent extends ManageDeliveryEvent {
  final List<Order> orders;

  UpdateCompletedOrdersEvent(this.orders);
  @override
  String toString() => 'UpdateCompletedOrdersEvent';
}
