part of 'checkout_bloc.dart';

@immutable
abstract class CheckoutEvent {}

class ProceedOrderEvent extends CheckoutEvent {
  final int paymentMethod;
  final String uid;
  final List<Cart> cartList;

  ProceedOrderEvent(this.paymentMethod, this.uid, this.cartList);

  @override
  String toString() => 'ProceedOrderEvent';
}

class PlaceOrderEvent extends CheckoutEvent {
  final int paymentMethod;
  final String uid;
  final List<Cart> cartList;
  final String orderAmt;
  final String shippingAmt;
  final String discountAmt;
  final String totalAmt;
  final String taxAmt;
  final Card card;
  final String razorpayTxnId;

  PlaceOrderEvent({
    this.paymentMethod,
    this.uid,
    this.cartList,
    this.orderAmt,
    this.shippingAmt,
    this.discountAmt,
    this.totalAmt,
    this.taxAmt,
    this.card,
    this.razorpayTxnId,
  });

  @override
  String toString() => 'PlaceOrderEvent';
}
