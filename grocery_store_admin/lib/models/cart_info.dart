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

  factory CartInfo.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return CartInfo(
      discountAmt: data['discountAmt'],
      discountPer: data['discountPer'],
      shippingAmt: data['shippingAmt'],
      taxPer: data['taxPer'],
    );
  }
}
