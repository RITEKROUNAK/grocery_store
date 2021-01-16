import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/models/message.dart';
import 'package:ecommerce_store_admin/models/message_analytics.dart';
import 'package:ecommerce_store_admin/models/product.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

part 'messages_event.dart';
part 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  final UserDataRepository userDataRepository;

  StreamSubscription messageAnalyticsSubscription;

  MessagesBloc({@required this.userDataRepository}) : super(null);

  MessagesState get initialState => MessagesInitial();

  @override
  Future<void> close() {
    print('Closing Messages BLOC');
    messageAnalyticsSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<MessagesState> mapEventToState(
    MessagesEvent event,
  ) async* {
    if (event is GetMessagesAnalyticsEvent) {
      yield* mapGetMessagesAnalyticsEventToState();
    }
    if (event is PostAnswerEvent) {
      yield* mapPostAnswerEventToState(event.id, event.ans, event.queId);
    }
    if (event is UpdateMessagesAnalyticsEvent) {
      yield* mapUpdateOrderAnalyticsEventToState(event.messageAnalytics);
    }
  }

  Stream<MessagesState> mapGetMessagesAnalyticsEventToState() async* {
    yield GetMessageAnalyticsInProgressState();
    try {
      messageAnalyticsSubscription?.cancel();
      messageAnalyticsSubscription =
          userDataRepository.getMessageAnalytics().listen((messageAnalytics) {
        add(UpdateMessagesAnalyticsEvent(messageAnalytics));
      }, onError: (err) {
        print(err);
        return GetMessageAnalyticsFailedState();
      });
    } catch (e) {
      print(e);
      yield GetMessageAnalyticsFailedState();
    }
  }

  Stream<MessagesState> mapUpdateOrderAnalyticsEventToState(
      MessageAnalytics messageAnalytics) async* {
    yield GetMessageAnalyticsCompletedState(messageAnalytics: messageAnalytics);
  }

  Stream<MessagesState> mapPostAnswerEventToState(
      String id, String ans, String queId) async* {
    yield PostAnswerInProgressState();
    try {
      bool isPosted = await userDataRepository.postAnswer(id, ans, queId);
      if (isPosted) {
        yield PostAnswerCompletedState();
      } else {
        yield PostAnswerFailedState();
      }
    } catch (e) {
      print(e);
      yield PostAnswerFailedState();
    }
  }
}
