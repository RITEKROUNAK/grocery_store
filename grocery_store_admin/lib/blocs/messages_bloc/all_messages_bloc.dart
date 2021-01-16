import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/models/message.dart';
import 'package:ecommerce_store_admin/models/message_analytics.dart';
import 'package:ecommerce_store_admin/models/product.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

import 'messages_bloc.dart';

class AllMessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  final UserDataRepository userDataRepository;


  AllMessagesBloc({@required this.userDataRepository}) : super(null);

  MessagesState get initialState => AllMessagesInitial();

  @override
  Stream<MessagesState> mapEventToState(
    MessagesEvent event,
  ) async* {
    if (event is GetAllMessagesEvent) {
      yield* mapGetAllMessagesEventToState();
    }
  }

  Stream<MessagesState> mapGetAllMessagesEventToState() async* {
    yield GetAllMessagesInProgressState();
    try {
      List<Product> products = await userDataRepository.getAllMessages();
      if (products != null) {
        yield GetAllMessagesCompletedState(products);
      } else {
        yield GetAllMessagesFailedState();
      }
    } catch (e) {
      print(e);
      yield GetAllMessagesFailedState();
    }
  }
}
