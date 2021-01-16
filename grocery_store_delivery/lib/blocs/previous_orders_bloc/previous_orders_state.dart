part of 'previous_orders_bloc.dart';

@immutable
abstract class PreviousOrdersState {}

class PreviousOrdersInitial extends PreviousOrdersState {}

class GetPreviousOrdersInProgressState extends PreviousOrdersState {
  @override
  String toString() => 'GetPreviousOrdersInProgressState';
}

class GetPreviousOrdersFailedState extends PreviousOrdersState {
  @override
  String toString() => 'GetPreviousOrdersFailedState';
}

class GetPreviousOrdersCompletedState extends PreviousOrdersState {
  final List<Order> previousOrders;

  GetPreviousOrdersCompletedState(this.previousOrders);

  @override
  String toString() => 'GetPreviousOrdersCompletedState';
}
