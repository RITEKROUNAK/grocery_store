import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_store/models/cart_info.dart';
import 'package:grocery_store/models/payment_methods.dart';

class CartValues {
  CartInfo cartInfo;
  PaymentMethods paymentMethods;

  CartValues({
    this.cartInfo,
    this.paymentMethods,
  });
}
