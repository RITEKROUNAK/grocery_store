part of 'manage_cart_bloc.dart';

@immutable
abstract class ManageCartState {}

class ManageCartInitial extends ManageCartState {}

class GetCartInfoCompletedState extends ManageCartState {
  final CartInfo cartInfo;
  GetCartInfoCompletedState(this.cartInfo);

  String toString() => 'GetCartInfoCompletedState';
}

class GetCartInfoFailedState extends ManageCartState {
  String toString() => 'GetCartInfoFailedState';
}

class GetCartInfoInProgressState extends ManageCartState {
  String toString() => 'GetCartInfoInProgressState';
}

class UpdateCartInfoCompletedState extends ManageCartState {
  String toString() => 'UpdateCartInfoCompletedState';
}

class UpdateCartInfoFailedState extends ManageCartState {
  String toString() => 'UpdateCartInfoFailedState';
}

class UpdateCartInfoInProgressState extends ManageCartState {
  String toString() => 'UpdateCartInfoInProgressState';
}
