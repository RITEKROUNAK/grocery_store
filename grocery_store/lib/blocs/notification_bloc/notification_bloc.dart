import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:grocery_store/models/user_notification.dart';
import 'package:grocery_store/repositories/user_data_repository.dart';
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
      yield* mapGetAllNotificationsEventToState(event.uid);
    }
    if (event is NotificationUpdateEvent) {
      yield* mapNotificationUpdateEventToState(event.userNotification);
    }
    if (event is NotificationMarkReadEvent) {
      yield* mapNotificationMarkReadEventToState(event.uid);
    }
  }

  Stream<NotificationState> mapGetAllNotificationsEventToState(
      String uid) async* {
    yield GetAllNotificationsInProgressState();
    try {
      notificationSubscription?.cancel();
      notificationSubscription =
          userDataRepository.getNotifications(uid).listen(
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
      UserNotification userNotification) async* {
    yield GetNotificationsUpdateState(userNotification);
  }

  Stream<NotificationState> mapNotificationMarkReadEventToState(
      String uid) async* {
    yield NotificationMarkReadInProgressState();
    try {
      await userDataRepository.markNotificationRead(uid);
      yield NotificationMarkReadCompletedState();
    } catch (e) {
      print(e);
      yield NotificationMarkReadFailedState();
    }
  }
}
