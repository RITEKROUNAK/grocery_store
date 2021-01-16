import 'package:cloud_firestore/cloud_firestore.dart';

class Banner {
  MiddleBanner middleBanner;
  BottomBanner bottomBanner;
  List topBanner;
  Banner({
    this.bottomBanner,
    this.middleBanner,
    this.topBanner,
  });

  factory Banner.fromFirestore(DocumentSnapshot snap) {
    Map data = snap.data();
    return Banner(
      bottomBanner: BottomBanner.fromFirestore(data['bottomBanner']),
      topBanner: data['topBanner'],
      middleBanner: MiddleBanner.fromFirestore(data['middleBanner']),
    );
  }
}

class MiddleBanner {
  String category;
  String middleBanner;

  MiddleBanner({
    this.category,
    this.middleBanner,
  });

  factory MiddleBanner.fromFirestore(Map map) {
    return MiddleBanner(
      category: map['category'],
      middleBanner: map['middleBanner'],
    );
  }
}

class BottomBanner {
  String category;
  String bottomBanner;

  BottomBanner({
    this.category,
    this.bottomBanner,
  });

  factory BottomBanner.fromFirestore(Map map) {
    return BottomBanner(
      category: map['category'],
      bottomBanner: map['bottomBanner'],
    );
  }
}
