import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/models/category.dart';
import 'package:ecommerce_store_admin/models/inventory_analytics.dart';
import 'package:ecommerce_store_admin/models/product.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final UserDataRepository userDataRepository;

  StreamSubscription inventoryAnalyticsSubscription;


  InventoryBloc({this.userDataRepository}) : super(null);
  @override
  InventoryState get initialState => InventoryInitial();
@override
  Future<void> close() {
        print('Closing Inventory BLOC');
    inventoryAnalyticsSubscription?.cancel();
    return super.close();
  }


  @override
  Stream<InventoryState> mapEventToState(
    InventoryEvent event,
  ) async* {

    if (event is  GetInventoryAnalyticsEvent) {
      yield* mapGetInventoryAnalyticsEventToState();
    }
      if (event is UpdateInventoryAnalyticsEvent) {
      yield* mapUpdateOrderAnalyticsEventToState(event.inventoryAnalytics);
    }
  }

 Stream<InventoryState> mapGetInventoryAnalyticsEventToState()async*{
   yield GetInventoryAnalyticsInProgressState();
   try {
     inventoryAnalyticsSubscription?.cancel();
      inventoryAnalyticsSubscription =
          userDataRepository.getInventoryAnalytics().listen((inventoryAnalytics) {
        add(UpdateInventoryAnalyticsEvent(inventoryAnalytics));
      }, onError: (err) {
        print(err);
        return GetInventoryAnalyticsFailedState();
      });
   } catch (e) {
     print(e);
     yield GetInventoryAnalyticsFailedState();
   }
 }

  Stream<InventoryState> mapUpdateOrderAnalyticsEventToState(InventoryAnalytics inventoryAnalytics)async*{
   yield GetInventoryAnalyticsCompletedState(inventoryAnalytics: inventoryAnalytics);
   
 }
}
