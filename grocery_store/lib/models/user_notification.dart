import 'package:cloud_firestore/cloud_firestore.dart';

class UserNotification {
  String uid;
  bool unread;
  List<Notification> notifications;

  UserNotification({
    this.notifications,
    this.uid,
    this.unread,
  });

  factory UserNotification.fromFirestore(DocumentSnapshot documentSnapshot) {
    return UserNotification(
      notifications: List<Notification>.from(
        documentSnapshot.data()['notifications'].map(
          (notif) {
            return Notification.fromMap(notif);
          },
        ),
      ),
      uid: documentSnapshot.data()['uid'],
      unread: documentSnapshot.data()['unread'],
    );
  }
}

class Notification {
  String notificationBody;
  String notificationId;
  String notificationTitle;
  String notificationType;
  String orderId;
  Timestamp timestamp;

  Notification({
    this.notificationBody,
    this.notificationId,
    this.notificationTitle,
    this.notificationType,
    this.orderId,
    this.timestamp,
  });

  factory Notification.fromMap(Map<dynamic, dynamic> map) {
    return Notification(
      notificationBody: map['notificationBody'],
      notificationId: map['notificationId'],
      notificationTitle: map['notificationTitle'],
      notificationType: map['notificationType'],
      orderId: map['orderId'],
      timestamp: map['timestamp'],
    );
  }
}
