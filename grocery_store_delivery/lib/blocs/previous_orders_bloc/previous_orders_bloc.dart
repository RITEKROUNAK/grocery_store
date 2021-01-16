import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:grocery_store_delivery/models/order.dart';
import 'package:grocery_store_delivery/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

part 'previous_orders_event.dart';
part 'previous_orders_state.dart';

class PreviousOrdersBloc
    extends Bloc<PreviousOrdersEvent, PreviousOrdersState> {
  final UserDataRepository userDataRepository;
  StreamSubscription ordersSubscription;

  PreviousOrdersBloc({this.userDataRepository})
      : super(PreviousOrdersInitial());

  @override
  Future<void> close() {
    print('Closing Previous Orders BLOC');
    ordersSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<PreviousOrdersState> mapEventToState(
    PreviousOrdersEvent event,
  ) async* {
    if (event is GetPreviousOrdersEvent) {
      yield* mapGetPreviousOrdersEventToState(event.uid);
    }
    if (event is UpdatePreviousOrdersEvent) {
      yield* mapUpdatePreviousOrdersEventToState(event.orders);
    }
  }

  Stream<PreviousOrdersState> mapGetPreviousOrdersEventToState(
      String uid) async* {
    yield GetPreviousOrdersInProgressState();
    try {
      ordersSubscription?.cancel();
      ordersSubscription =
          userDataRepository.getPreviousOrders(uid).listen((orders) {
        add(UpdatePreviousOrdersEvent(orders));
      }, onError: (err) {
        print(err);
        return GetPreviousOrdersFailedState();
      });
    } catch (e) {
      print(e);
      yield GetPreviousOrdersFailedState();
    }
  }

  Stream<PreviousOrdersState> mapUpdatePreviousOrdersEventToState(
      List<Order> orders) async* {
    yield GetPreviousOrdersCompletedState(orders);
  }
}
