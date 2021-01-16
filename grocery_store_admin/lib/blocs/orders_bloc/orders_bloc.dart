import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/models/order.dart';
import 'package:ecommerce_store_admin/models/order_analytics.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final UserDataRepository userDataRepository;

  StreamSubscription orderAnalyticsSubscription;

  OrdersBloc({@required this.userDataRepository}) : super(null);

  @override
  OrdersState get initialState => OrdersInitialState();

  @override
  Future<void> close() {
    print('Closing Orders BLOC');
    orderAnalyticsSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<OrdersState> mapEventToState(
    OrdersEvent event,
  ) async* {
    if (event is GetOrderAnalyticsEvent) {
      yield* mapGetOrderAnalyticsEventToState();
    }
    if (event is UpdateOrderAnalyticsEvent) {
      yield* mapUpdateOrderAnalyticsEventToState(event.orderAnalytics);
    }
  }

  Stream<OrdersState> mapGetOrderAnalyticsEventToState() async* {
    yield GetOrderAnalyticsInProgressState();

    try {
      orderAnalyticsSubscription?.cancel();
      orderAnalyticsSubscription =
          userDataRepository.getOrderAnalytics().listen((orderAnalytics) {
        add(UpdateOrderAnalyticsEvent(orderAnalytics));
      }, onError: (err) {
        print(err);
        return GetOrderAnalyticsFailedState();
      });
    } catch (e) {
      print(e);
      yield GetOrderAnalyticsFailedState();
    }
  }

  Stream<OrdersState> mapUpdateOrderAnalyticsEventToState(
      OrderAnalytics orderAnalytics) async* {
    yield UpdateOrderAnalyticsState(orderAnalytics);
  }
}
