import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:grocery_store_delivery/repositories/user_data_repository.dart';
import 'manage_delivery_bloc.dart';

class AssignedDeliveryOrdersBloc
    extends Bloc<ManageDeliveryEvent, ManageDeliveryState> {
  final UserDataRepository userDataRepository;

  AssignedDeliveryOrdersBloc({this.userDataRepository})
      : super(ManageDeliveryInitial());

  @override
  Stream<ManageDeliveryState> mapEventToState(
    ManageDeliveryEvent event,
  ) async* {
    if (event is DeliverOrderEvent) {
      yield* mapDeliverOrderEventToState(event.deliverOrderMap);
    }
    if (event is CancelOrderEvent) {
      yield* mapCancelOrderEventToState(event.cancelOrderMap);
    }
  }

  Stream<ManageDeliveryState> mapDeliverOrderEventToState(
      Map deliverOrderMap) async* {
    yield DeliverOrderInProgressState();
    try {
      bool isDelivered = await userDataRepository.deliverOrder(deliverOrderMap);
      if (isDelivered) {
        yield DeliverOrderCompletedState();
      } else {
        yield DeliverOrderFailedState();
      }
    } catch (e) {
      print(e);
      yield DeliverOrderFailedState();
    }
  }

  Stream<ManageDeliveryState> mapCancelOrderEventToState(
      Map cancelOrderMap) async* {
    yield CancelOrderInProgressState();
    try {
      bool isCancelled = await userDataRepository.cancelOrder(cancelOrderMap);
      if (isCancelled) {
        yield CancelOrderCompletedState();
      } else {
        yield CancelOrderFailedState();
      }
    } catch (e) {
      print(e);
      yield CancelOrderFailedState();
    }
  }
}
