part of 'notification_bloc.dart';

@immutable
abstract class NotificationEvent {}

class GetAllNotificationsEvent extends NotificationEvent {
  @override
  String toString() => 'GetAllNotificationsEvent';
}

class NotificationUpdateEvent extends NotificationEvent {
  final SellerNotification sellerNotification;
  NotificationUpdateEvent(this.sellerNotification);

  @override
  String toString() => 'NotificationUpdateEvent';
}

class NotificationMarkReadEvent extends NotificationEvent {
  @override
  String toString() => 'NotificationMarkReadEvent';
}
