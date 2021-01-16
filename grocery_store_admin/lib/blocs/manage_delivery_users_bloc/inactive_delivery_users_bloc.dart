import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/models/delivery_user.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';

import 'manage_delivery_users_bloc.dart';

class InactiveDeliveryUsersBloc
    extends Bloc<ManageDeliveryUsersEvent, ManageDeliveryUsersState> {
  final UserDataRepository userDataRepository;

  InactiveDeliveryUsersBloc({this.userDataRepository}) : super(null);

  @override
  Stream<ManageDeliveryUsersState> mapEventToState(
    ManageDeliveryUsersEvent event,
  ) async* {
    if (event is GetInactiveDeliveryUsersEvent) {
      yield* mapGetInactiveDeliveryUsersEventToState();
    }
  }

  Stream<ManageDeliveryUsersState>
      mapGetInactiveDeliveryUsersEventToState() async* {
    yield GetInactiveDeliveryUsersInProgressState();
    try {
      List<DeliveryUser> deliveryUsers =
          await userDataRepository.getInactiveDeliveryUsers();
      if (deliveryUsers != null) {
        yield GetInactiveDeliveryUsersCompletedState(deliveryUsers);
      } else {
        yield GetInactiveDeliveryUsersFailedState();
      }
    } catch (e) {
      print(e);
      yield GetInactiveDeliveryUsersFailedState();
    }
  }
}
