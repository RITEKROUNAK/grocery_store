import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/models/message.dart';
import 'package:ecommerce_store_admin/models/message_analytics.dart';
import 'package:ecommerce_store_admin/models/product.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

import 'messages_bloc.dart';



class NewMessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  final UserDataRepository userDataRepository;

  StreamSubscription newMessagesSubscription;

  NewMessagesBloc({@required this.userDataRepository}) : super(null);

  MessagesState get initialState => NewMessagesInitial();

  @override
  Future<void> close() {
    print('Closing New Messages BLOC');
    newMessagesSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<MessagesState> mapEventToState(
    MessagesEvent event,
  ) async* {

    if (event is GetNewMessagesEvent) {
      yield* mapGetNewMessagesEventToState();
    }
  
  }

Stream<MessagesState> mapGetNewMessagesEventToState()async*{
  yield GetNewMessagesInProgressState();
  try {
       List<Product> products = await userDataRepository.getNewMessages();
      if (products != null) {
        yield GetNewMessagesCompletedState(products);
      } else {
        yield GetNewMessagesFailedState();
      }
  } catch (e) {
    print(e);
    yield GetNewMessagesFailedState();
  }
}
}
