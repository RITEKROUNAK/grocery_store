import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_store_admin/models/order.dart';
import 'package:ecommerce_store_admin/models/user.dart';
import 'package:ecommerce_store_admin/models/user_analytics.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

part 'manage_users_event.dart';
part 'manage_users_state.dart';

class ManageUsersBloc extends Bloc<ManageUsersEvent, ManageUsersState> {
  final UserDataRepository userDataRepository;
  StreamSubscription userAnalyticsSubscription;

  ManageUsersBloc({this.userDataRepository}) : super(null);

  ManageUsersState get initialState => ManageUsersInitialState();

  @override
  Future<void> close() {
    print('Closing User BLOC');
    userAnalyticsSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<ManageUsersState> mapEventToState(
    ManageUsersEvent event,
  ) async* {
    if (event is GetUserAnalyticsEvent) {
      yield* mapGetUserAnalyticsEventToState();
    }
    if (event is UpdateUserAnalyticsEvent) {
      yield* mapUpdateUserAnalyticsEventToState(event.userAnalytics);
    }
  }

  Stream<ManageUsersState> mapGetUserAnalyticsEventToState() async* {
    yield GetUserAnalyticsInProgressState();

    try {
      userAnalyticsSubscription?.cancel();
      userAnalyticsSubscription =
          userDataRepository.getUserAnalytics().listen((userAnalytics) {
        add(UpdateUserAnalyticsEvent(userAnalytics: userAnalytics));
      }, onError: (err) {
        print(err);
        return GetUserAnalyticsFailedState();
      });
    } catch (e) {
      print(e);
      yield GetUserAnalyticsFailedState();
    }
  }

  Stream<ManageUsersState> mapUpdateUserAnalyticsEventToState(
      UserAnalytics userAnalytics) async* {
    yield GetUserAnalyticsCompletedState(userAnalytics: userAnalytics);
  }
}
