import 'dart:io';

import 'package:grocery_store_delivery/models/delivery_notification.dart';
import 'package:grocery_store_delivery/models/order.dart';
import 'package:grocery_store_delivery/models/user.dart';
import 'package:grocery_store_delivery/providers/user_data_provider.dart';

import 'base_repository.dart';

class UserDataRepository extends BaseRepository {
  UserDataProvider userDataProvider = UserDataProvider();

  Stream<List<Order>> getAllAssignedOrders(String uid) =>
      userDataProvider.getAllAssignedOrders(uid);

  Stream<List<Order>> getCompletedOrders(String uid) =>
      userDataProvider.getCompletedOrders(uid);

  Future<bool> deliverOrder(Map deliverOrderMap) =>
      userDataProvider.deliverOrder(deliverOrderMap);

  Future<bool> cancelOrder(Map cancelOrderMap) =>
      userDataProvider.cancelOrder(cancelOrderMap);

  Stream<List<Order>> getPreviousOrders(String uid) =>
      userDataProvider.getPreviousOrders(uid);

  Future<DeliveryUser> getAccountDetails() =>
      userDataProvider.getAccountDetails();

  Future<bool> updateAccountDetails(DeliveryUser user, File profileImage) =>
      userDataProvider.updateAccountDetails(user, profileImage);

  //notifications
  Stream<DeliveryNotification> getNotifications() =>
      userDataProvider.getNotifications();

  Future<void> markNotificationRead() =>
      userDataProvider.markNotificationRead();

  @override
  void dispose() {
    userDataProvider.dispose();
  }
}
