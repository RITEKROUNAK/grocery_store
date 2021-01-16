import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryUser {
  String accountStatus;
  bool activated;
  bool firstLogin;
  String uid;
  String name;
  String email;
  String password;
  String mobileNo;
  String profileImageUrl;
  String tokenId;
  Timestamp timestamp;

  DeliveryUser({
    this.accountStatus,
    this.firstLogin,
    this.uid,
    this.email,
    this.password,
    this.mobileNo,
    this.name,
    this.profileImageUrl,
    this.tokenId,
    this.activated,
    this.timestamp,
  });

  factory DeliveryUser.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return DeliveryUser(
      accountStatus: data['accountStatus'],
      firstLogin: data['firstLogin'],
      uid: data['uid'],
      email: data['email'],
      password: data['password'],
      mobileNo: data['mobileNo'],
      name: data['name'],
      profileImageUrl: data['profileImageUrl'],
      tokenId: data['tokenId'],
      activated: data['activated'],
      timestamp: data['timestamp'],
    );
  }
  factory DeliveryUser.fromMap(Map data) {
    return DeliveryUser(
      accountStatus: data['accountStatus'],
      firstLogin: data['firstLogin'],
      uid: data['uid'],
      email: data['email'],
      password: data['password'],
      mobileNo: data['mobileNo'],
      name: data['name'],
      profileImageUrl: data['profileImageUrl'],
      tokenId: data['tokenId'],
      activated: data['activated'],
      timestamp: data['timestamp'],
    );
  }
}
