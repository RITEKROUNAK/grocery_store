import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

dynamic notificationData;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class FirebaseService {
  static init(context, uid, User currentUser) {
    updateFirebaseToken(currentUser);
    initFCM(uid, context, currentUser);
    configureFirebaseListeners(context, currentUser);
  }
}

//FCM
updateFirebaseToken(User currentUser) {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  print(currentUser.uid);

  firebaseMessaging.getToken().then((token) {
    print(token);
    FirebaseFirestore.instance
        .collection('DeliveryUsers')
        .doc(currentUser.uid)
        .update({
      'tokenId': token,
    });
  });
}

initFCM(String uid, context, User currentUser) async {
  flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  var android = new AndroidInitializationSettings('delivery');
  var ios = new IOSInitializationSettings();
  var initSetting = new InitializationSettings(android, ios);
  flutterLocalNotificationsPlugin.initialize(
    initSetting,
    onSelectNotification: (data) async {
      print('Send to my orders ::: $notificationData');
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => OrdersPage(
      //       // currentUser: currentUser,
      //     ),
      //   ),
      // );
    },
  );
}

configureFirebaseListeners(context, User currentUser) {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  firebaseMessaging.configure(
    onBackgroundMessage: firebaseBackgroundMessageHandler,
    onMessage: (Map<String, dynamic> message) async {
      print('onMessage: $message');
      notificationData = message;
      showNotification(
        notificationData,
        notificationData['data']['type'],
        context,
      );
    },
    onLaunch: (Map<String, dynamic> message) async {
      notificationData = message;
      print('onLaunch: $notificationData');
      //send user to my orders

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => HomeScreen(),
      //   ),
      // );
    },
    onResume: (Map<String, dynamic> message) async {
      notificationData = message;
      print('onResume: $notificationData');

      //send to my orders
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => MyOrdersScreen(
      //       currentUser: currentUser,
      //     ),
      //   ),
      // );
    },
  );
}

showNotification(
  dynamic data,
  String notificationType,
  context,
) async {
  var aNdroid = new AndroidNotificationDetails(
    'channelId',
    'channel_name',
    'desc',
    importance: Importance.High,
  );
  var iOS = new IOSNotificationDetails();
  var platform = new NotificationDetails(aNdroid, iOS);

  await flutterLocalNotificationsPlugin.show(Random().nextInt(100),
      data['notification']['title'], data['notification']['body'], platform);
}

Future<dynamic> firebaseBackgroundMessageHandler(
    Map<String, dynamic> message) async {
  notificationData = message;
  print(notificationData);

  return Future<void>.value();
}
