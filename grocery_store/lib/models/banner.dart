import 'package:cloud_firestore/cloud_firestore.dart';

class Banner {
  Map<dynamic, dynamic> bottomBanner;
  Map<dynamic, dynamic> middleBanner;
  List topBanner;

  Banner({
    this.bottomBanner,
    this.middleBanner,
    this.topBanner,
  });

  factory Banner.fromFirestore(DocumentSnapshot documentSnapshot) {
    Map data = documentSnapshot.data();

    return Banner(
        bottomBanner: data['bottomBanner'],
        middleBanner: data['middleBanner'],
        topBanner: data['topBanner']);
  }
}
