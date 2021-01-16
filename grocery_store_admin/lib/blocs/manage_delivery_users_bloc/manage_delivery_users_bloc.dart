import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/models/delivery_user.dart';
import 'package:ecommerce_store_admin/models/delivery_user_analytics.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

part 'manage_delivery_users_event.dart';
part 'manage_delivery_users_state.dart';

class ManageDeliveryUsersBloc
    extends Bloc<ManageDeliveryUsersEvent, ManageDeliveryUsersState> {
  final UserDataRepository userDataRepository;
  StreamSubscription deliveryUserAnalyticsSubscription;

  ManageDeliveryUsersBloc({this.userDataRepository}) : super(null);

  @override
  Future<void> close() {
    print('Closing Delivery User BLOC');
    deliveryUserAnalyticsSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<ManageDeliveryUsersState> mapEventToState(
    ManageDeliveryUsersEvent event,
  ) async* {
    if (event is GetDeliveryUserAnalyticsEvent) {
      yield* mapGetDeliveryUserAnalyticsEventToState();
    }
    if (event is UpdateDeliveryUserAnalyticsEvent) {
      yield* mapUpdateDeliveryUserAnalyticsEventToState(
          event.deliveryUserAnalytics);
    }
  }

  Stream<ManageDeliveryUsersState>
      mapGetDeliveryUserAnalyticsEventToState() async* {
    yield GetDeliveryUserAnalyticsInProgressState();

    try {
      deliveryUserAnalyticsSubscription?.cancel();
      deliveryUserAnalyticsSubscription =
          userDataRepository.getDeliveryUserAnalytics().listen((userAnalytics) {
        add(UpdateDeliveryUserAnalyticsEvent(userAnalytics));
      }, onError: (err) {
        print(err);
        return GetDeliveryUserAnalyticsFailedState();
      });
    } catch (e) {
      print(e);
      yield GetDeliveryUserAnalyticsFailedState();
    }
  }

  Stream<ManageDeliveryUsersState> mapUpdateDeliveryUserAnalyticsEventToState(
      DeliveryUserAnalytics deliveryUserAnalytics) async* {
    yield GetDeliveryUserAnalyticsCompletedState(deliveryUserAnalytics);
  }
}
