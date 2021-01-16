part of 'checkout_bloc.dart';

@immutable
abstract class CheckoutState {}

class CheckoutInitial extends CheckoutState {}

class ProceedOrderInProgressState extends CheckoutState {
  @override
  String toString() => 'ProceedOrderInProgressState';
}

class ProceedOrderFailedState extends CheckoutState {
  @override
  String toString() => 'ProceedOrderFailedState';
}

//TODO: change the return object later
class ProceedOrderCompletedState extends CheckoutState {
  final String res;
  ProceedOrderCompletedState(this.res);

  @override
  String toString() => 'ProceedOrderCompletedState';
}

class PlaceOrderInProgressState extends CheckoutState {
  @override
  String toString() => 'PlaceOrderInProgressState';
}

class PlaceOrderFailedState extends CheckoutState {
  @override
  String toString() => 'PlaceOrderFailedState';
}

class PlaceOrderCompletedState extends CheckoutState {
  @override
  String toString() => 'PlaceOrderCompletedState';
}
