import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryUserAnalytics {
  var activeUsers;
  var inactiveUsers;
  var allUsers;
  var deactivatedUsers;
  var activatedUsers;

  DeliveryUserAnalytics({
    this.activeUsers,
    this.allUsers,
    this.inactiveUsers,
    this.deactivatedUsers,
    this.activatedUsers,
  });

  factory DeliveryUserAnalytics.fromFirestore(DocumentSnapshot snapshot) {
    Map data = snapshot.data();
    return DeliveryUserAnalytics(
      activeUsers: data['activeUsers'],
      inactiveUsers: data['inactiveUsers'],
      allUsers: data['allUsers'],
      deactivatedUsers: data['deactivatedUsers'],
      activatedUsers: data['activatedUsers'],
    );
  }
}
