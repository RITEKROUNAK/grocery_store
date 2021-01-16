import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/models/order.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';
import 'orders_bloc.dart';

class DeliveredOrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final UserDataRepository userDataRepository;

  DeliveredOrdersBloc({@required this.userDataRepository}) : super(null);

  @override
  OrdersState get initialState => DeliveredOrdersInitialState();

  @override
  Stream<OrdersState> mapEventToState(
    OrdersEvent event,
  ) async* {
    if (event is GetDeliveredOrdersEvent) {
      yield* mapGetDeliveredOrdersEventToState();
    }
  }

  Stream<OrdersState> mapGetDeliveredOrdersEventToState() async* {
    yield GetDeliveredOrdersInProgressState();

    try {
      List<Order> deliveredOrders =
          await userDataRepository.getDeliveredOrders();
      if (deliveredOrders != null) {
        yield GetDeliveredOrdersCompletedState(deliveredOrders);
      } else {
        yield GetDeliveredOrdersFailedState();
      }
    } catch (e) {
      print(e);
      yield GetDeliveredOrdersFailedState();
    }
  }
}
