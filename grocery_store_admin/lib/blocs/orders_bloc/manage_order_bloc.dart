import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/models/order.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';
import 'orders_bloc.dart';

class ManageOrderBloc extends Bloc<OrdersEvent, OrdersState> {
  final UserDataRepository userDataRepository;

  ManageOrderBloc({@required this.userDataRepository}) : super(null);

  OrdersState get initialState => ManageOrderInitialState();

  @override
  Stream<OrdersState> mapEventToState(
    OrdersEvent event,
  ) async* {
    if (event is ProceedOrderEvent) {
      yield* mapProceedOrderEventToState(event.proceedOrderMap);
    }
    if (event is CancelOrderEvent) {
      yield* mapCancelOrderEventToState(event.cancelOrderMap);
    }
  }

  Stream<OrdersState> mapProceedOrderEventToState(Map proceedOrderMap) async* {
    yield ProceedOrderInProgressState();

    try {
      bool isProceeded = await userDataRepository.proceedOrder(proceedOrderMap);
      if (isProceeded) {
        yield ProceedOrderCompletedState();
      } else {
        yield ProceedOrderFailedState();
      }
    } catch (e) {
      print(e);
      yield ProceedOrderFailedState();
    }
  }

  Stream<OrdersState> mapCancelOrderEventToState(Map cancelOrderMap) async* {
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
