import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:grocery_store_delivery/models/delivery_notification.dart';
import 'package:grocery_store_delivery/repositories/user_data_repository.dart';

import 'package:meta/meta.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final UserDataRepository userDataRepository;
  StreamSubscription notificationSubscription;

  NotificationBloc({this.userDataRepository}) : super(null);

  NotificationState get initialState => NotificationInitial();

  @override
  Future<void> close() {
    print('CLOSING NOTIFICATION BLOC');
    notificationSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<NotificationState> mapEventToState(
    NotificationEvent event,
  ) async* {
    if (event is GetAllNotificationsEvent) {
      yield* mapGetAllNotificationsEventToState();
    }
    if (event is NotificationUpdateEvent) {
      yield* mapNotificationUpdateEventToState(event.deliveryNotification);
    }
    if (event is NotificationMarkReadEvent) {
      yield* mapNotificationMarkReadEventToState();
    }
  }

  Stream<NotificationState> mapGetAllNotificationsEventToState() async* {
    yield GetAllNotificationsInProgressState();
    try {
      notificationSubscription?.cancel();
      notificationSubscription = userDataRepository.getNotifications().listen(
        (notification) {
          print(
            'INSIDE BLOC AFTER RECEIVING :: ${notification.notifications.length}',
          );
          add(NotificationUpdateEvent(notification));
        },
        onError: (err) {
          print(err);
          return GetAllNotificationsFailedState();
        },
      );
    } catch (e) {
      print(e);
      yield GetAllNotificationsFailedState();
    }
  }

  Stream<NotificationState> mapNotificationUpdateEventToState(
      DeliveryNotification deliveryNotification) async* {
    yield GetNotificationsUpdateState(deliveryNotification);
  }

  Stream<NotificationState> mapNotificationMarkReadEventToState() async* {
    yield NotificationMarkReadInProgressState();
    try {
      await userDataRepository.markNotificationRead();
      yield NotificationMarkReadCompletedState();
    } catch (e) {
      print(e);
      yield NotificationMarkReadFailedState();
    }
  }
}
