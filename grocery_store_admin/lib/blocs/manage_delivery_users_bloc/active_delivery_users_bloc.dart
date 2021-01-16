import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/models/delivery_user.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';

import 'manage_delivery_users_bloc.dart';

class ActiveDeliveryUsersBloc
    extends Bloc<ManageDeliveryUsersEvent, ManageDeliveryUsersState> {
  final UserDataRepository userDataRepository;

  ActiveDeliveryUsersBloc({this.userDataRepository}) : super(null);

  @override
  Stream<ManageDeliveryUsersState> mapEventToState(
    ManageDeliveryUsersEvent event,
  ) async* {
    if (event is GetActiveDeliveryUsersEvent) {
      yield* mapGetActiveDeliveryUsersEventToState();
    }
  }

  Stream<ManageDeliveryUsersState>
      mapGetActiveDeliveryUsersEventToState() async* {
    yield GetActiveDeliveryUsersInProgressState();
    try {
      List<DeliveryUser> deliveryUsers =
          await userDataRepository.getActiveDeliveryUsers();
      if (deliveryUsers != null) {
        yield GetActiveDeliveryUsersCompletedState(deliveryUsers);
      } else {
        yield GetActiveDeliveryUsersFailedState();
      }
    } catch (e) {
      print(e);
      yield GetActiveDeliveryUsersFailedState();
    }
  }
}
