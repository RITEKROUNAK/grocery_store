import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:grocery_store_delivery/models/order.dart';
import 'package:grocery_store_delivery/repositories/user_data_repository.dart';
import 'manage_delivery_bloc.dart';

class CompletedDeliveryOrdersBloc
    extends Bloc<ManageDeliveryEvent, ManageDeliveryState> {
  final UserDataRepository userDataRepository;
  StreamSubscription ordersSubscription;

  CompletedDeliveryOrdersBloc({this.userDataRepository})
      : super(ManageDeliveryInitial());

  @override
  Future<void> close() {
    print('Closing Completed Orders BLOC');
    ordersSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<ManageDeliveryState> mapEventToState(
    ManageDeliveryEvent event,
  ) async* {
    if (event is GetCompletedOrdersEvent) {
      yield* mapGetCompletedOrdersEventToState(event.uid);
    }
    if (event is UpdateCompletedOrdersEvent) {
      yield* mapUpdateCompletedOrdersEventToState(event.orders);
    }
  }

  Stream<ManageDeliveryState> mapGetCompletedOrdersEventToState(
      String uid) async* {
    yield GetCompletedOrdersInProgressState();
    try {
      ordersSubscription?.cancel();
      ordersSubscription =
          userDataRepository.getCompletedOrders(uid).listen((orders) {
        add(UpdateCompletedOrdersEvent(orders));
      }, onError: (err) {
        print(err);
        return GetCompletedOrdersFailedState();
      });
    } catch (e) {
      print(e);
      yield GetCompletedOrdersFailedState();
    }
  }

  Stream<ManageDeliveryState> mapUpdateCompletedOrdersEventToState(
      List<Order> orders) async* {
    yield GetCompletedOrdersCompletedState(orders);
  }
}
