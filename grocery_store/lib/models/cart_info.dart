import 'package:cloud_firestore/cloud_firestore.dart';

class CartInfo {
  String discountAmt;
  String discountPer;
  String shippingAmt;
  String taxPer;

  CartInfo({
    this.discountAmt,
    this.discountPer,
    this.shippingAmt,
    this.taxPer,
  });

  factory CartInfo.fromFirestore(DocumentSnapshot documentSnapshot) {
    return CartInfo(
      discountAmt: documentSnapshot.data()['discountAmt'],
      discountPer: documentSnapshot.data()['discountPer'],
      shippingAmt: documentSnapshot.data()['shippingAmt'],
      taxPer: documentSnapshot.data()['taxPer'],
    );
  }

  factory CartInfo.fromHashmap(Map<String, dynamic> cartValues) {
    return CartInfo(
      discountAmt: cartValues['discountAmt'],
      discountPer: cartValues['discountPer'],
      shippingAmt: cartValues['shippingAmt'],
      taxPer: cartValues['taxPer'],
    );
  }
}
