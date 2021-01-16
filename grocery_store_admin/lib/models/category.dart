import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String categoryName;
  String imageLink;
  String categoryId;
  List<SubCategory> subCategories;

  Category({
    this.categoryName,
    this.imageLink,
    this.subCategories,
    this.categoryId,
  });

  factory Category.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();

    return Category(
      categoryName: data['categoryName'],
      imageLink: data['imageLink'],
      categoryId: data['categoryId'],
      subCategories: List<SubCategory>.from(
        data['subCategories'].map(
          (item) => SubCategory(
            subCategoryName: item['subCategoryName'],
          ),
        ),
      ),
    );
  }
}

class SubCategory {
  String subCategoryName;
  SubCategory({
    this.subCategoryName,
  });

  factory SubCategory.fromHashmap(Map<dynamic, dynamic> subCategory) {
    return SubCategory(
      subCategoryName: subCategory['subCategoryName'],
    );
  }
}
