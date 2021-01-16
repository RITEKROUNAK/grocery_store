import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/models/delivery_user.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';

import 'manage_delivery_users_bloc.dart';

class DeactivatedDeliveryUsersBloc
    extends Bloc<ManageDeliveryUsersEvent, ManageDeliveryUsersState> {
  final UserDataRepository userDataRepository;

  DeactivatedDeliveryUsersBloc({this.userDataRepository}) : super(null);

  @override
  Stream<ManageDeliveryUsersState> mapEventToState(
    ManageDeliveryUsersEvent event,
  ) async* {
    if (event is GetDeactivatedDeliveryUsersEvent) {
      yield* mapGetDeactivatedDeliveryUsersEventToState();
    }
  }

  Stream<ManageDeliveryUsersState>
      mapGetDeactivatedDeliveryUsersEventToState() async* {
    yield GetDeactivatedDeliveryUsersInProgressState();
    try {
      List<DeliveryUser> deliveryUsers =
          await userDataRepository.getDeactivatedDeliveryUsers();
      if (deliveryUsers != null) {
        yield GetDeactivatedDeliveryUsersCompletedState(deliveryUsers);
      } else {
        yield GetDeactivatedDeliveryUsersFailedState();
      }
    } catch (e) {
      print(e);
      yield GetDeactivatedDeliveryUsersFailedState();
    }
  }
}
