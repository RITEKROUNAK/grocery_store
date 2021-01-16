import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryAnalytics {
  var lowInventory;
  var allCategories;

  InventoryAnalytics({
    this.allCategories,
    this.lowInventory,
  });

  factory InventoryAnalytics.fromFirestore(DocumentSnapshot snapshot) {
    return InventoryAnalytics(
      lowInventory: snapshot.data()['lowInventory'],
      allCategories: snapshot.data()['allCategories'],
    );
  }
}
