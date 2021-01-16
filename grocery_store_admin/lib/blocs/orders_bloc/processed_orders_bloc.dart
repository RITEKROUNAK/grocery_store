import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/models/order.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';
import 'orders_bloc.dart';

class ProcessedOrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final UserDataRepository userDataRepository;

  ProcessedOrdersBloc({@required this.userDataRepository}) : super(null);

  @override
  OrdersState get initialState => ProcessedOrdersInitialState();

  @override
  Stream<OrdersState> mapEventToState(
    OrdersEvent event,
  ) async* {
    if (event is GetProcessedOrdersEvent) {
      yield* mapGetProcessedOrdersEventToState();
    }
  }

  Stream<OrdersState> mapGetProcessedOrdersEventToState() async* {
    yield GetProcessedOrdersInProgressState();

    try {
      List<Order> processedOrders =
          await userDataRepository.getProcessedOrders();
      if (processedOrders != null) {
        yield GetProcessedOrdersCompletedState(processedOrders);
      } else {
        yield GetProcessedOrdersFailedState();
      }
    } catch (e) {
      print(e);
      yield GetProcessedOrdersFailedState();
    }
  }
}
