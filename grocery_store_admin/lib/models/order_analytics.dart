import 'package:cloud_firestore/cloud_firestore.dart';

class OrderAnalytics {
  var cancelledOrders;
  var cancelledSales;
  var deliveredOrders;
  var deliveredSales;
  var newOrders;
  var newSales;
  var processedOrders;
  var processedSales;
  var totalOrders;
  var totalSales;

  OrderAnalytics({
    this.cancelledOrders,
    this.cancelledSales,
    this.deliveredOrders,
    this.deliveredSales,
    this.newOrders,
    this.newSales,
    this.processedOrders,
    this.processedSales,
    this.totalOrders,
    this.totalSales,
  });

  factory OrderAnalytics.fromFirestore(DocumentSnapshot documentSnapshot) {
    return OrderAnalytics(
      cancelledOrders: documentSnapshot.data()['cancelledOrders'],
      cancelledSales: documentSnapshot.data()['cancelledSales'],
      deliveredOrders: documentSnapshot.data()['deliveredOrders'],
      deliveredSales: documentSnapshot.data()['deliveredSales'],
      newOrders: documentSnapshot.data()['newOrders'],
      newSales: documentSnapshot.data()['newSales'],
      processedOrders: documentSnapshot.data()['processedOrders'],
      processedSales: documentSnapshot.data()['processedSales'],
      totalOrders: documentSnapshot.data()['totalOrders'],
      totalSales: documentSnapshot.data()['totalSales'],
    );
  }
}
