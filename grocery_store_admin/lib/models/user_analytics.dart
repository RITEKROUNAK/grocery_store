import 'package:cloud_firestore/cloud_firestore.dart';

class UserAnalytics {
  var activeUsers;
  var inactiveUsers;
  var allUsers;
  var blockedUsers;

  UserAnalytics({
    this.activeUsers,
    this.allUsers,
    this.inactiveUsers,
    this.blockedUsers,
  });

  factory UserAnalytics.fromFirestore(DocumentSnapshot snapshot) {
    Map data = snapshot.data();
    return UserAnalytics(
      activeUsers: data['activeUsers'],
      inactiveUsers: data['inactiveUsers'],
      allUsers: data['allUsers'],
      blockedUsers: data['blockedUsers'],
    );
  }
}
