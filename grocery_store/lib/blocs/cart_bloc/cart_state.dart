part of 'cart_bloc.dart';

@immutable
abstract class CartState {}

class CartInitial extends CartState {
  @override
  String toString() => 'CartInitialState';
}

class AddToCartInProgressState extends CartState {
  @override
  String toString() => 'AddToCartInProgressState';
}

class AddToCartFailedState extends CartState {
  @override
  String toString() => 'AddToCartFailedState';
}

class AddToCartCompletedState extends CartState {
  @override
  String toString() => 'AddToCartCompletedState';
}

class RemoveFromCartInProgressState extends CartState {
  @override
  String toString() => 'RemoveFromCartInProgressState';
}

class RemoveFromCartFailedState extends CartState {
  @override
  String toString() => 'RemoveFromCartFailedState';
}

class RemoveFromCartCompletedState extends CartState {
  @override
  String toString() => 'RemoveFromCartCompletedState';
}

class CartCountInitialState extends CartState {
  @override
  String toString() => 'CartCountInitialState';
}

class GetCartCountInProgressState extends CartState {
  @override
  String toString() => 'GetCartCountInProgressState';
}

class GetCartCountState extends CartState {
  final int cartCount;

  GetCartCountState(this.cartCount);

  @override
  String toString() => 'GetCartCountState';
}

class GetCartCountFailedState extends CartState {
  @override
  String toString() => 'GetCartCountFailedState';
}

class CartCountUpdateState extends CartState {
  final int cartCount;
  CartCountUpdateState(this.cartCount);

  @override
  String toString() => 'CartCountUpdateState';
}

class GetCartProductsFailedState extends CartState {
  @override
  String toString() => 'GetCartProductsFailedState';
}

class GetCartProductsInProgressState extends CartState {
  @override
  String toString() => 'GetCartProductsInProgressState';
}

class GetCartProductsCompletedState extends CartState {
  final List<Cart> cartProductsList;

  GetCartProductsCompletedState(this.cartProductsList);

  @override
  String toString() => 'GetCartProductsCompletedState';
}

class IncreaseQuantityCompletedState extends CartState {
  @override
  String toString() => 'IncreaseQuantityCompletedState';
}

class IncreaseQuantityFailedState extends CartState {
  @override
  String toString() => 'IncreaseQuantityFailedState';
}

class IncreaseQuantityInProgressState extends CartState {
  @override
  String toString() => 'IncreaseQuantityInProgressState';
}

class DecreaseQuantityCompletedState extends CartState {
  @override
  String toString() => 'DecreaseQuantityCompletedState';
}

class DecreaseQuantityFailedState extends CartState {
  @override
  String toString() => 'DecreaseQuantityFailedState';
}

class DecreaseQuantityInProgressState extends CartState {
  @override
  String toString() => 'DecreaseQuantityInProgressState';
}

class GetCartValuesCompletedState extends CartState {
  final CartValues cartValues;

  GetCartValuesCompletedState(this.cartValues);
  @override
  String toString() => 'GetCartValuesCompletedState';
}

class GetCartValuesFailedState extends CartState {
  @override
  String toString() => 'GetCartValuesFailedState';
}

class GetCartValuesInProgressState extends CartState {
  @override
  String toString() => 'GetCartValuesInProgressState';
}
