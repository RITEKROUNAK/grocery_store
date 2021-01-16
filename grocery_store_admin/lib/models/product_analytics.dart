import 'package:cloud_firestore/cloud_firestore.dart';

class ProductAnalytics {
  var activeProducts;
  var inactiveProducts;
  var featuredProducts;
  var trendingProducts;
  var allProducts;

  ProductAnalytics({
    this.activeProducts,
    this.allProducts,
    this.featuredProducts,
    this.inactiveProducts,
    this.trendingProducts,
  });

  factory ProductAnalytics.fromFirestore(DocumentSnapshot snapshot) {
    return ProductAnalytics(
      activeProducts: snapshot.data()['activeProducts'],
      inactiveProducts: snapshot.data()['inactiveProducts'],
      featuredProducts: snapshot.data()['featuredProducts'],
      trendingProducts: snapshot.data()['trendingProducts'],
      allProducts: snapshot.data()['allProducts'],
    );
  }
}
