part of 'cart_bloc.dart';

@immutable
abstract class CartEvent {}

class AddToCartEvent extends CartEvent {
  final String productId;
  final String uid;

  AddToCartEvent(this.productId, this.uid);

  @override
  String toString() => 'AddToCartEvent';
}

class RemoveFromCartEvent extends CartEvent {
  final String productId;
  final String uid;

  RemoveFromCartEvent(this.productId, this.uid);

  @override
  String toString() => 'RemoveFromCartEvent';
}

class IncreaseQuantityEvent extends CartEvent {
  final String quantity;
  final String uid;
  final String productId;

  IncreaseQuantityEvent({this.quantity, this.uid, this.productId});
  @override
  String toString() => 'IncreaseQuantityEvent';
}

class DecreaseQuantityEvent extends CartEvent {
  final String quantity;
  final int index;

  DecreaseQuantityEvent(this.quantity, this.index);
  @override
  String toString() => 'DecreaseQuantityEvent';
}

class InitializeCartEvent extends CartEvent {
  @override
  String toString() => 'InitializeCartEvent';
}

class GetCartCountEvent extends CartEvent {
  final String uid;
  GetCartCountEvent(this.uid);

  @override
  String toString() => 'GetCartCountEvent';
}

class CartCountUpdateEvent extends CartEvent {
  final int cartCount;
  CartCountUpdateEvent(this.cartCount);

  @override
  String toString() => 'CartCountUpdateEvent';
}

class GetCartProductsEvent extends CartEvent {
  final String uid;
  GetCartProductsEvent(this.uid);

  @override
  String toString() => 'GetCartProductsEvent';
}

class GetCartValuesEvent extends CartEvent {
  @override
  String toString() => 'GetCartValuesEvent';
}
