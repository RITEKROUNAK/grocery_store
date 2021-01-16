import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String categoryName;
  String imageLink;
  List<dynamic> subCategories;

  Category({
    this.categoryName,
    this.imageLink,
    this.subCategories,
  });

  factory Category.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();

    return Category(
      categoryName: data['categoryName'],
      imageLink: data['imageLink'],
      subCategories: data['subCategories'],
    );
  }
}

class SubCategory {
  Map<String, dynamic> subCategories;
  SubCategory({
    this.subCategories,
  });
}
