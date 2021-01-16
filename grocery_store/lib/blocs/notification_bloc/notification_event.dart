part of 'notification_bloc.dart';

@immutable
abstract class NotificationEvent {}

class GetAllNotificationsEvent extends NotificationEvent {
  final String uid;
  GetAllNotificationsEvent(this.uid);

  @override
  String toString() => 'GetAllNotificationsEvent';
}

class NotificationUpdateEvent extends NotificationEvent {
  final UserNotification userNotification;
  NotificationUpdateEvent(this.userNotification);

  @override
  String toString() => 'NotificationUpdateEvent';
}

class NotificationMarkReadEvent extends NotificationEvent {
  final String uid;
  NotificationMarkReadEvent(this.uid);

  @override
  String toString() => 'NotificationMarkReadEvent';
}
