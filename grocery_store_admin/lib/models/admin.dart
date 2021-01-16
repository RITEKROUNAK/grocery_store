import 'package:cloud_firestore/cloud_firestore.dart';

class Admin {
  String accountStatus;
  bool activated;
  String uid;
  String name;
  String email;
  String mobileNo;
  String tokenId;
  String password;
  bool primaryAdmin;
  String profileImageUrl;
  Timestamp timestamp;

  Admin({
    this.accountStatus,
    this.activated,
    this.email,
    this.mobileNo,
    this.name,
    this.tokenId,
    this.uid,
    this.primaryAdmin,
    this.profileImageUrl,
    this.password,
    this.timestamp,
  });

  factory Admin.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return Admin(
      accountStatus: data['accountStatus'],
      activated: data['activated'],
      uid: data['uid'],
      name: data['name'],
      email: data['email'],
      mobileNo: data['mobileNo'],
      tokenId: data['tokenId'],
      primaryAdmin: data['primaryAdmin'],
      profileImageUrl: data['profileImageUrl'],
      password: data['password'],
      timestamp: data['timestamp'],
    );
  }
}
