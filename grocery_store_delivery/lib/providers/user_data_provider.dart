import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:grocery_store_delivery/config/paths.dart';
import 'package:grocery_store_delivery/models/delivery_notification.dart';
import 'package:grocery_store_delivery/models/order.dart';
import 'package:grocery_store_delivery/models/user.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

import 'base_provider.dart';

class UserDataProvider extends BaseUserDataProvider {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth mAuth = FirebaseAuth.instance;

  @override
  void dispose() {}

  @override
  Future<bool> cancelOrder(Map cancelOrderMap) async {
    try {
      switch (cancelOrderMap['paymentMethod']) {
        case 'COD':
          //no refund
          db.collection(Paths.ordersPath).doc(cancelOrderMap['orderId']).set(
            {
              'cancelledBy': 'Delivery',
              'deliveryDetails': {
                'deliveryStatus': 'Completed',
                'deliveryDate':
                    '${new DateFormat('dd MMM yyyy').format(DateTime.now())}',
                'reason': cancelOrderMap['reason'],
              },
              'orderStatus': 'Cancelled',
              'refundStatus': 'NA',
              'deliveryTimestamp': FieldValue.serverTimestamp(),
            },
            SetOptions(
              merge: true,
            ),
          );
          return true;
          break;
        case 'CARD':
          //refund
          db.collection(Paths.ordersPath).doc(cancelOrderMap['orderId']).set(
            {
              'cancelledBy': 'Delivery',
              'deliveryDetails': {
                'deliveryStatus': 'Completed',
                'deliveryDate':
                    '${new DateFormat('dd MMM yyyy').format(DateTime.now())}',
                'reason': cancelOrderMap['reason'],
              },
              'orderStatus': 'Cancelled',
              'refundStatus': 'Not processed',
              'deliveryTimestamp': FieldValue.serverTimestamp(),
            },
            SetOptions(
              merge: true,
            ),
          );
          return true;
          break;
        case 'RAZORPAY':
          //refund
          db.collection(Paths.ordersPath).doc(cancelOrderMap['orderId']).set(
            {
              'cancelledBy': 'Delivery',
              'deliveryDetails': {
                'deliveryStatus': 'Completed',
                'deliveryDate':
                    '${new DateFormat('dd MMM yyyy').format(DateTime.now())}',
                'reason': cancelOrderMap['reason'],
              },
              'orderStatus': 'Cancelled',
              'refundStatus': 'Not processed',
              'deliveryTimestamp': FieldValue.serverTimestamp(),
            },
            SetOptions(
              merge: true,
            ),
          );
          return true;
          break;
        case 'PAYPAL':
          break;
        default:
      }

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<bool> deliverOrder(Map deliverOrderMap) async {
    try {
      db.collection(Paths.ordersPath).doc(deliverOrderMap['orderId']).set(
        {
          'deliveryDetails': {
            'deliveryStatus': 'Completed',
            'deliveryDate':
                '${new DateFormat('dd MMM yyyy').format(DateTime.now())}',
          },
          'orderStatus': 'Delivered',
          'deliveryTimestamp': FieldValue.serverTimestamp(),
        },
        SetOptions(
          merge: true,
        ),
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Stream<List<Order>> getAllAssignedOrders(String uid) {
    List<Order> assignedOrders = List();

    try {
      CollectionReference collectionReference = db.collection(Paths.ordersPath);

      return collectionReference
          .where('orderStatus', isEqualTo: 'Out for delivery')
          .where('deliveryDetails.uid', isEqualTo: uid)
          .snapshots()
          .transform(StreamTransformer<QuerySnapshot, List<Order>>.fromHandlers(
            handleData: (QuerySnapshot snap, EventSink<List<Order>> sink) {
              if (snap.docs != null) {
                assignedOrders = List<Order>.from(
                  snap.docs.map(
                    (e) => Order.fromFirestore(e),
                  ),
                );
                sink.add(assignedOrders);
              }
            },
            handleError: (error, stackTrace, sink) {
              print('ERROR: $error');
              print(stackTrace);
              sink.addError(error);
            },
          ));
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Stream<List<Order>> getCompletedOrders(String uid) {
    List<Order> completedOrders = List();

    try {
      CollectionReference collectionReference = db.collection(Paths.ordersPath);

      String date = new DateFormat('dd MMM yyyy').format(DateTime.now());

      return collectionReference
          .where('deliveryDetails.deliveryStatus', isEqualTo: 'Completed')
          .where('deliveryDetails.uid', isEqualTo: uid)
          .where('deliveryDetails.deliveryDate', isEqualTo: date)
          .snapshots()
          .transform(StreamTransformer<QuerySnapshot, List<Order>>.fromHandlers(
            handleData: (QuerySnapshot snap, EventSink<List<Order>> sink) {
              if (snap.docs != null) {
                completedOrders = List<Order>.from(
                  snap.docs.map(
                    (e) => Order.fromFirestore(e),
                  ),
                );
                sink.add(completedOrders);
              }
            },
            handleError: (error, stackTrace, sink) {
              print('ERROR: $error');
              print(stackTrace);
              sink.addError(error);
            },
          ));
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Stream<List<Order>> getPreviousOrders(String uid) {
    List<Order> previousOrders = List();

    try {
      CollectionReference collectionReference = db.collection(Paths.ordersPath);

      // String date = new DateFormat('dd MMM yyyy').format(DateTime.now());

      return collectionReference
          .where('deliveryDetails.deliveryStatus', isEqualTo: 'Completed')
          .where('deliveryDetails.uid', isEqualTo: uid)
          .snapshots()
          .transform(StreamTransformer<QuerySnapshot, List<Order>>.fromHandlers(
            handleData: (QuerySnapshot snap, EventSink<List<Order>> sink) {
              if (snap.docs != null) {
                String date =
                    new DateFormat('dd MMM yyyy').format(DateTime.now());

                for (var order in snap.docs) {
                  if (order.data()['deliveryDetails']['deliveryDate'] != date) {
                    previousOrders.add(Order.fromFirestore(order));
                  }
                }

                // previousOrders = List<Order>.from(
                //   snap.documents.map(
                //     (e) => Order.fromFirestore(e),
                //   ),
                // );
                sink.add(previousOrders);
              }
            },
            handleError: (error, stackTrace, sink) {
              print('ERROR: $error');
              print(stackTrace);
              sink.addError(error);
            },
          ));
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<DeliveryUser> getAccountDetails() async {
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      User firebaseUser = firebaseAuth.currentUser;

      if (firebaseUser != null) {
        DocumentSnapshot documentSnapshot = await db
            .collection(Paths.deliveryUsersPath)
            .doc(firebaseUser.uid)
            .get();
        DeliveryUser currentUser = DeliveryUser.fromFirestore(documentSnapshot);
        return currentUser;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<bool> updateAccountDetails(
      DeliveryUser user, File profileImage) async {
    try {
      if (profileImage != null) {
        //upload profile image first
        var uuid = Uuid().v4();
        StorageReference storageReference =
            firebaseStorage.ref().child('deliveryProfileImages/$uuid');
        StorageUploadTask storageUploadTask =
            storageReference.putFile(profileImage);
        StorageTaskSnapshot storageTaskSnapshot =
            await storageUploadTask.onComplete;
        var url = await storageTaskSnapshot.ref.getDownloadURL();

        await db.collection(Paths.deliveryUsersPath).doc(user.uid).set(
          {
            'name': user.name,
            'mobileNo': user.mobileNo,
            'profileImageUrl': url,
          },
          SetOptions(
            merge: true,
          ),
        );
      } else {
        //just update details
        await db.collection(Paths.deliveryUsersPath).doc(user.uid).set(
          {
            'name': user.name,
            'mobileNo': user.mobileNo,
            'profileImageUrl': user.profileImageUrl,
          },
          SetOptions(
            merge: true,
          ),
        );
      }

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Stream<DeliveryNotification> getNotifications() {
    String uid = mAuth.currentUser.uid;

    DocumentReference documentReference =
        db.collection(Paths.noticationsPath).doc(uid);

    print('inside notifications');
    return documentReference.snapshots().transform(
          StreamTransformer<DocumentSnapshot,
              DeliveryNotification>.fromHandlers(
            handleData: (DocumentSnapshot docSnap,
                EventSink<DeliveryNotification> sink) {
              DeliveryNotification userNotification =
                  DeliveryNotification.fromFirestore(docSnap);
              print('UID :: ${userNotification.uid}');
              sink.add(userNotification);
            },
            handleError: (error, stackTrace, sink) {
              print('ERROR: $error');
              print(stackTrace);
              sink.addError(error);
            },
          ),
        );
  }

  @override
  Future<void> markNotificationRead() async {
    try {
      String uid = mAuth.currentUser.uid;

      await db.collection(Paths.noticationsPath).doc(uid).set({
        'unread': false,
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
      return null;
    }
  }
}
