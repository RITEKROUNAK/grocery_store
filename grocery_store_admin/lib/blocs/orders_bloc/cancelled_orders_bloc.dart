import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/models/order.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';
import 'orders_bloc.dart';

class CancelledOrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final UserDataRepository userDataRepository;

  CancelledOrdersBloc({@required this.userDataRepository}) : super(null);

  @override
  OrdersState get initialState => CancelledOrdersInitialState();

  @override
  Stream<OrdersState> mapEventToState(
    OrdersEvent event,
  ) async* {
    if (event is GetCancelledOrdersEvent) {
      yield* mapGetCancelledOrdersEventToState();
    }
    if (event is GetPendingRefundOrdersEvent) {
      yield* mapGetPendingRefundOrdersEventToState();
    }
  }

  Stream<OrdersState> mapGetCancelledOrdersEventToState() async* {
    yield GetCancelledOrdersInProgressState();

    try {
      List<Order> cancelledOrders =
          await userDataRepository.getCancelledOrders();
      if (cancelledOrders != null) {
        yield GetCancelledOrdersCompletedState(cancelledOrders);
      } else {
        yield GetCancelledOrdersFailedState();
      }
    } catch (e) {
      print(e);
      yield GetCancelledOrdersFailedState();
    }
  }

  Stream<OrdersState> mapGetPendingRefundOrdersEventToState() async* {
    yield GetPendingRefundOrdersInProgressState();

    try {
      List<Order> pendingRefundOrders =
          await userDataRepository.getPendingRefundOrders();
      if (pendingRefundOrders != null) {
        yield GetPendingRefundOrdersCompletedState(pendingRefundOrders);
      } else {
        yield GetPendingRefundOrdersFailedState();
      }
    } catch (e) {
      print(e);
      yield GetPendingRefundOrdersFailedState();
    }
  }
}
