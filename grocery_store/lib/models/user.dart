import 'package:cloud_firestore/cloud_firestore.dart';

class GroceryUser {
  String accountStatus;
  bool isBlocked;
  String uid;
  String name;
  String email;
  String mobileNo;
  String profileImageUrl;
  String tokenId;
  String defaultAddress;
  List<Address> address;
  List<dynamic> wishlist;
  Map<String, dynamic> cart;
  String loggedInVia;

  GroceryUser({
    this.accountStatus,
    this.isBlocked,
    this.uid,
    this.email,
    this.mobileNo,
    this.name,
    this.profileImageUrl,
    this.defaultAddress,
    this.address,
    this.tokenId,
    this.wishlist,
    this.cart,
    this.loggedInVia,
  });

  factory GroceryUser.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return GroceryUser(
      accountStatus: data['accountStatus'],
      isBlocked: data['isBlocked'],
      uid: data['uid'],
      email: data['email'],
      mobileNo: data['mobileNo'],
      name: data['name'],
      profileImageUrl: data['profileImageUrl'],
      defaultAddress: data['defaultAddress'],
      address: List<Address>.from(
        data['address'].map(
          (address) {
            return Address.fromHashmap(address);
          },
        ),
      ),
      tokenId: data['tokenId'],
      wishlist: data['wishlist'],
      cart: data['cart'],
      loggedInVia: data['loggedInVia'],
    );
  }
  factory GroceryUser.fromMap(Map data) {
    return GroceryUser(
      accountStatus: data['accountStatus'],
      isBlocked: data['isBlocked'],
      uid: data['uid'],
      email: data['email'],
      mobileNo: data['mobileNo'],
      name: data['name'],
      profileImageUrl: data['profileImageUrl'],
      address: data['address'],
      tokenId: data['tokenId'],
      wishlist: data['wishlist'],
      cart: data['cart'],
      loggedInVia: data['loggedInVia'],
    );
  }
}

class Address {
  String city;
  String state;
  String pincode;
  String landmark;
  String addressLine1;
  String addressLine2;
  String country;
  String houseNo;

  Address({
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.country,
    this.houseNo,
    this.landmark,
    this.pincode,
    this.state,
  });

  factory Address.fromHashmap(Map<String, dynamic> address) {
    return Address(
      addressLine1: address['addressLine1'],
      addressLine2: address['addressLine2'],
      city: address['city'],
      country: address['country'],
      houseNo: address['houseNo'],
      landmark: address['landmark'],
      pincode: address['pincode'],
      state: address['state'],
    );
  }
}
