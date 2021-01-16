import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryUser {
  String accountStatus;
  bool activated;
  String email;
  bool firstLogin;
  String mobileNo;
  String name;
  String password;
  String profileImageUrl;
  String tokenId;
  String uid;

  DeliveryUser({
    this.email,
    this.mobileNo,
    this.name,
    this.profileImageUrl,
    this.tokenId,
    this.uid,
    this.accountStatus,
    this.activated,
    this.firstLogin,
    this.password,
  });

  factory DeliveryUser.fromFirestore(DocumentSnapshot snapshot) {
    Map data = snapshot.data();
    return DeliveryUser(
      accountStatus: data['accountStatus'],
      activated: data['activated'],
      email: data['email'],
      firstLogin: data['firstLogin'],
      mobileNo: data['mobileNo'],
      name: data['name'],
      password: data['password'],
      profileImageUrl: data['profileImageUrl'],
      tokenId: data['tokenId'],
      uid: data['uid'],
    );
  }
}
