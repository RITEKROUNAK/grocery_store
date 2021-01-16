import 'package:cloud_firestore/cloud_firestore.dart';

class UserReport {
  String productId;
  String reportDescription;
  Timestamp timestamp;
  String uid;
  String userName;

  UserReport({
    this.productId,
    this.reportDescription,
    this.timestamp,
    this.uid,
    this.userName,
  });

  factory UserReport.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return UserReport(
      productId: data['productId'],
      reportDescription: data['reportDescription'],
      timestamp: data['timestamp'],
      uid: data['uid'],
      userName: data['userName'],
    );
  }
}
