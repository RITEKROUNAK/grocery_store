import 'package:cloud_firestore/cloud_firestore.dart';

class GroceryUser {
  String accountStatus;
  String uid;
  String name;
  String email;
  bool isBlocked;
  String mobileNo;
  String profileImageUrl;
  String tokenId;
  String defaultAddress;
  List<Address> address;
  List<dynamic> wishlist;
  List<dynamic> orders;
  Map<String, dynamic> cart;

  GroceryUser({
    this.accountStatus,
    this.uid,
    this.name,
    this.email,
    this.isBlocked,
    this.mobileNo,
    this.profileImageUrl,
    this.defaultAddress,
    this.address,
    this.tokenId,
    this.wishlist,
    this.orders,
    this.cart,
  });

  factory GroceryUser.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return GroceryUser(
      accountStatus: data['accountStatus'],
      uid: data['uid'],
      name: data['name'],
      email: data['email'],
      isBlocked: data['isBlocked'],
      mobileNo: data['mobileNo'],
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
      orders: data['orders'],
      cart: data['cart'],
    );
  }
  factory GroceryUser.fromMap(Map data) {
    return GroceryUser(
      accountStatus: data['accountStatus'],
      uid: data['uid'],
      name: data['name'],
      email: data['email'],
      isBlocked: data['isBlocked'],
      mobileNo: data['mobileNo'],
      profileImageUrl: data['profileImageUrl'],
      address: data['address'],
      tokenId: data['tokenId'],
      wishlist: data['wishlist'],
      orders: data['orders'],
      cart: data['cart'],
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
