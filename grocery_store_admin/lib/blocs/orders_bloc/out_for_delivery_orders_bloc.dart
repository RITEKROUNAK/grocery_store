import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/models/order.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';
import 'orders_bloc.dart';

class OutForDeliveryOrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final UserDataRepository userDataRepository;

  OutForDeliveryOrdersBloc({@required this.userDataRepository}) : super(null);

  OrdersState get initialState => OutForDeliveryOrdersInitialState();

  @override
  Stream<OrdersState> mapEventToState(
    OrdersEvent event,
  ) async* {
    if (event is GetOutForDeliveryOrdersEvent) {
      yield* mapGetOutForDeliveryOrdersEventToState();
    }
  }

  Stream<OrdersState> mapGetOutForDeliveryOrdersEventToState() async* {
    yield GetOutForDeliveryOrdersInProgressState();

    try {
      List<Order> outForDeliveryOrders =
          await userDataRepository.getOutForDeliveryOrders();
      if (outForDeliveryOrders != null) {
        yield GetOutForDeliveryOrdersCompletedState(outForDeliveryOrders);
      } else {
        yield GetOutForDeliveryOrdersFailedState();
      }
    } catch (e) {
      print(e);
      yield GetOutForDeliveryOrdersFailedState();
    }
  }
}
