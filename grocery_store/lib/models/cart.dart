import 'package:cloud_firestore/cloud_firestore.dart';

import 'product.dart';

class Cart {
  Product product;
  String quantity;

  Cart({
    this.product,
    this.quantity,
  });

  factory Cart.fromFirestore(
      DocumentSnapshot documentSnapshot, String quantity) {
    return Cart(
      product: Product.fromFirestore(documentSnapshot),
      quantity: quantity,
    );
  }
}
