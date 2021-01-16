import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:grocery_store_delivery/models/order.dart';
import 'package:grocery_store_delivery/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

part 'manage_delivery_event.dart';
part 'manage_delivery_state.dart';

class ManageDeliveryBloc
    extends Bloc<ManageDeliveryEvent, ManageDeliveryState> {
  final UserDataRepository userDataRepository;
  StreamSubscription ordersSubscription;

  ManageDeliveryBloc({this.userDataRepository})
      : super(ManageDeliveryInitial());

  @override
  Future<void> close() {
    print('Closing Assigned Orders BLOC');
    ordersSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<ManageDeliveryState> mapEventToState(
    ManageDeliveryEvent event,
  ) async* {
    if (event is GetAllAssignedOrdersEvent) {
      yield* mapGetAllAssignedOrdersEventToState(event.uid);
    }
    if (event is UpdateAllAssignedOrdersEvent) {
      yield* mapUpdateAllAssignedOrdersEventToState(event.orders);
    }
  }

  Stream<ManageDeliveryState> mapGetAllAssignedOrdersEventToState(String uid) async* {
    yield GetAllAssignedOrdersInProgressState();
    try {
      ordersSubscription?.cancel();
      ordersSubscription =
          userDataRepository.getAllAssignedOrders(uid).listen((orders) {
        add(UpdateAllAssignedOrdersEvent(orders));
      }, onError: (err) {
        print(err);
        return GetAllAssignedOrdersFailedState();
      });
    } catch (e) {
      print(e);
      yield GetAllAssignedOrdersFailedState();
    }
  }

  Stream<ManageDeliveryState> mapUpdateAllAssignedOrdersEventToState(
      List<Order> assignedOrders) async* {
    yield GetAllAssignedOrdersCompletedState(assignedOrders);
  }
}
