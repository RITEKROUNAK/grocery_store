import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentMethods {
  bool stripe;
  bool cod;
  bool razorpay;
  bool storePickup;
  bool paypal;

  PaymentMethods({
    this.stripe,
    this.cod,
    this.razorpay,
    this.storePickup,
    this.paypal,
  });

  factory PaymentMethods.fromFirestore(DocumentSnapshot documentSnapshot) {
    Map map = documentSnapshot.data();
    return PaymentMethods(
      cod: map['cod'],
      stripe: map['stripe'],
      razorpay: map['razorpay'],
      storePickup: map['storePickup'],
      paypal: map['paypal'],
    );
  }
}
