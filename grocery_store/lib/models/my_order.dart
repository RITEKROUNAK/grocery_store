import 'package:cloud_firestore/cloud_firestore.dart';

class MyOrder {
  String cancelledBy;
  String reason;
  String refundStatus;
  String refundTransactionId;
  CustDetails custDetails;
  DeliveryDetails deliveryDetails;
  Timestamp deliveryTimestamp;
  String orderId;
  String orderStatus;
  Timestamp orderTimestamp;
  String paymentMethod;
  List<OrderProduct> products;
  String transactionId;
  Charges charges;

  MyOrder({
    this.cancelledBy,
    this.reason,
    this.refundStatus,
    this.refundTransactionId,
    this.custDetails,
    this.deliveryDetails,
    this.deliveryTimestamp,
    this.orderId,
    this.orderStatus,
    this.orderTimestamp,
    this.paymentMethod,
    this.products,
    this.transactionId,
    this.charges,
  });

  factory MyOrder.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return MyOrder(
      cancelledBy: data['cancelledBy'],
      reason: data['reason'],
      refundStatus: data['refundStatus'],
      refundTransactionId: data['refundTransactionId'],
      custDetails: CustDetails.fromHashmap(data['custDetails']),
      deliveryDetails: DeliveryDetails.fromHashmap(data['deliveryDetails']),
      deliveryTimestamp: data['deliveryTimestamp'],
      orderId: data['orderId'],
      orderStatus: data['orderStatus'],
      orderTimestamp: data['orderTimestamp'],
      paymentMethod: data['paymentMethod'],
      products: List<OrderProduct>.from(
        data['products'].map(
          (data) {
            return OrderProduct(
              category: data['category'],
              id: data['id'],
              ogPrice: data['ogPrice'],
              price: data['price'],
              productImage: data['productImage'],
              quantity: data['quantity'],
              subCategory: data['subCategory'],
              totalAmt: data['totalAmt'],
              unitQuantity: data['unitQuantity'],
              name: data['name'],
            );
          },
        ),
      ),
      transactionId: data['transactionId'],
      charges: Charges.fromHashmap(data['charges']),
    );
  }
}

class Charges {
  String orderAmt;
  String shippingAmt;
  String discountAmt;
  String totalAmt;
  String taxAmt;

  Charges({
    this.discountAmt,
    this.orderAmt,
    this.shippingAmt,
    this.totalAmt,
    this.taxAmt,
  });

  factory Charges.fromHashmap(Map<String, dynamic> charges) {
    return Charges(
      discountAmt: charges['discountAmt'],
      orderAmt: charges['orderAmt'],
      shippingAmt: charges['shippingAmt'],
      totalAmt: charges['totalAmt'],
      taxAmt: charges['taxAmt'],
    );
  }
}

class DeliveryDetails {
  String deliveryStatus;
  String mobileNo;
  String name;
  String uid;
  String otp;
  String reason;
  Timestamp timestamp;

  DeliveryDetails({
    this.mobileNo,
    this.name,
    this.uid,
    this.deliveryStatus,
    this.otp,
    this.reason,
    this.timestamp,
  });

  factory DeliveryDetails.fromHashmap(Map<String, dynamic> deliveryDetails) {
    return DeliveryDetails(
      deliveryStatus: deliveryDetails['deliveryStatus'],
      mobileNo: deliveryDetails['mobileNo'],
      name: deliveryDetails['name'],
      uid: deliveryDetails['uid'],
      otp: deliveryDetails['otp'],
      reason: deliveryDetails['reason'],
      timestamp: deliveryDetails['timestamp'],
    );
  }
}

class CustDetails {
  String address;
  String mobileNo;
  String name;
  String uid;

  CustDetails({
    this.address,
    this.mobileNo,
    this.name,
    this.uid,
  });

  factory CustDetails.fromHashmap(Map<String, dynamic> custDetails) {
    return CustDetails(
      address: custDetails['address'],
      mobileNo: custDetails['mobileNo'],
      name: custDetails['name'],
      uid: custDetails['uid'],
    );
  }
}

class OrderProduct {
  String category;
  String id;
  String ogPrice;
  String price;
  String productImage;
  String quantity;
  String subCategory;
  String totalAmt;
  String unitQuantity;
  String name;

  OrderProduct({
    this.category,
    this.id,
    this.ogPrice,
    this.price,
    this.productImage,
    this.quantity,
    this.subCategory,
    this.totalAmt,
    this.unitQuantity,
    this.name,
  });

  factory OrderProduct.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return OrderProduct(
      category: data['category'],
      id: data['id'],
      ogPrice: data['ogPrice'],
      price: data['price'],
      productImage: data['productImage'],
      quantity: data['quantity'],
      subCategory: data['subCategory'],
      totalAmt: data['totalAmt'],
      unitQuantity: data['unitQuantity'],
      name: data['name'],
    );
  }
}
