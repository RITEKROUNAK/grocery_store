import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_store_delivery/models/delivery_notification.dart';
import 'package:grocery_store_delivery/models/order.dart';
import 'package:grocery_store_delivery/models/user.dart';

abstract class BaseProvider {
  void dispose();
}

abstract class BaseAuthenticationProvider extends BaseProvider {
  Future<User> getCurrentUser();
  Future<String> signInWithEmail(String email, String password);
  Future<String> checkIfSignedIn();
  Future<bool> signOut();
  Future<bool> changePassword(DeliveryUser user);
}

abstract class BaseUserDataProvider extends BaseProvider {
  Future<bool> deliverOrder(Map deliverOrderMap);
  Future<bool> cancelOrder(Map cancelOrderMap);
  Stream<List<Order>> getAllAssignedOrders(String uid);
  Stream<List<Order>> getCompletedOrders(String uid);

  Stream<List<Order>> getPreviousOrders(String uid);

  Future<DeliveryUser> getAccountDetails();
  Future<bool> updateAccountDetails(DeliveryUser user, File profileImage);

  //notifications
  Stream<DeliveryNotification> getNotifications();
  Future<void> markNotificationRead();
}

abstract class BaseStorageProvider extends BaseProvider {}
