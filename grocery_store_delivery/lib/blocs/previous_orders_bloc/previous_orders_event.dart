part of 'previous_orders_bloc.dart';

@immutable
abstract class PreviousOrdersEvent {}

class GetPreviousOrdersEvent extends PreviousOrdersEvent {
  final String uid;

  GetPreviousOrdersEvent(this.uid);
}

class UpdatePreviousOrdersEvent extends PreviousOrdersEvent {
  final List<Order> orders;

  UpdatePreviousOrdersEvent(this.orders);
}
