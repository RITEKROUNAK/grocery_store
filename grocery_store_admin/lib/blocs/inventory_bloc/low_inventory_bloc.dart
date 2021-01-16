import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/models/product.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';

import 'inventory_bloc.dart';

class LowInventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final UserDataRepository userDataRepository;

  StreamSubscription lowInventorySubsciption;

  LowInventoryBloc({this.userDataRepository}) : super(null);

  @override
  Future<void> close() {
    print('Closing Low Inventory BLOC');
    lowInventorySubsciption?.cancel();
    return super.close();
  }

  InventoryState get initialState => LowInventoryInitial();

  @override
  Stream<InventoryState> mapEventToState(
    InventoryEvent event,
  ) async* {
    if (event is GetLowInventoryProductsEvent) {
      yield* mapGetLowInventoryProductsEventToState();
    }
    if (event is UpdateGetLowInventoryProductsEvent) {
      yield* mapUpdateGetLowInventoryProductsEventToState(
          event.lowInventoryProducts);
    }
    if (event is UpdateLowInventoryProductEvent) {
      yield* mapUpdateLowInventoryProductEventToState(event.id, event.quantity);
    }
  }

  Stream<InventoryState> mapUpdateGetLowInventoryProductsEventToState(
      List<Product> lowInventoryProducts) async* {
    yield GetLowInventoryProductsCompletedState(products: lowInventoryProducts);
  }

  Stream<InventoryState> mapGetLowInventoryProductsEventToState() async* {
    yield GetLowInventoryProductsInProgressState();
    try {
      lowInventorySubsciption?.cancel();
      lowInventorySubsciption =
          userDataRepository.getLowInventoryProducts().listen((lowInventory) {
        add(UpdateGetLowInventoryProductsEvent(lowInventory));
      }, onError: (err) {
        print(err);
        return GetLowInventoryProductsFailedState();
      });
    } catch (e) {
      print(e);
      yield GetLowInventoryProductsFailedState();
    }
  }

  Stream<InventoryState> mapUpdateLowInventoryProductEventToState(
      String id, int quantity) async* {
    yield UpdateLowInventoryProductInProgressState();
    try {
      bool isUpdated =
          await userDataRepository.updateLowInventoryProduct(id, quantity);
      if (isUpdated) {
        yield UpdateLowInventoryProductCompletedState();
      } else {
        yield UpdateLowInventoryProductFailedState();
      }
    } catch (e) {
      print(e);
      yield UpdateLowInventoryProductFailedState();
    }
  }
}
