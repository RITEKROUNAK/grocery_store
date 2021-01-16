import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/models/order.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';
import 'orders_bloc.dart';

class NewOrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final UserDataRepository userDataRepository;

  StreamSubscription newOrdersSubscription;

  NewOrdersBloc({@required this.userDataRepository}) : super(null);

  @override
  OrdersState get initialState => NewOrdersInitialState();

  @override
  Future<void> close() {
    print('Closing New Orders BLOC');
    newOrdersSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<OrdersState> mapEventToState(
    OrdersEvent event,
  ) async* {
    if (event is LoadNewOrdersEvent) {
      yield* mapLoadNewOrdersEventToState();
    }
    if (event is UpdateNewOrdersEvent) {
      yield* mapUpdateNewOrdersEventToState(event.newOrders);
    }
  }

  Stream<OrdersState> mapLoadNewOrdersEventToState() async* {
    yield LoadNewOrdersInProgressState();

    try {
      newOrdersSubscription?.cancel();
      newOrdersSubscription =
          userDataRepository.getNewOrders().listen((newOrders) {
        add(UpdateNewOrdersEvent(newOrders));
      }, onError: (err) {
        print(err);
        return LoadNewOrdersFailedState();
      });
    } catch (e) {
      print(e);
      yield LoadNewOrdersFailedState();
    }
  }

  Stream<OrdersState> mapUpdateNewOrdersEventToState(
      List<Order> newOrders) async* {
    yield UpdateNewOrdersCompletedState(
      newOrders: newOrders,
    );
  }
}
