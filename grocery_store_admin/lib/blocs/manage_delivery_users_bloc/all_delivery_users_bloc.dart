import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/models/delivery_user.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';

import 'manage_delivery_users_bloc.dart';

class AllDeliveryUsersBloc
    extends Bloc<ManageDeliveryUsersEvent, ManageDeliveryUsersState> {
  final UserDataRepository userDataRepository;

  AllDeliveryUsersBloc({this.userDataRepository}) : super(null);

  @override
  Stream<ManageDeliveryUsersState> mapEventToState(
    ManageDeliveryUsersEvent event,
  ) async* {
    if (event is GetAllDeliveryUsersEvent) {
      yield* mapGetAllDeliveryUsersEventToState();
    }
  }

  Stream<ManageDeliveryUsersState>
      mapGetAllDeliveryUsersEventToState() async* {
    yield GetAllDeliveryUsersInProgressState();
    try {
      List<DeliveryUser> deliveryUsers =
          await userDataRepository.getAllDeliveryUsers();
      if (deliveryUsers != null) {
        yield GetAllDeliveryUsersCompletedState(deliveryUsers);
      } else {
        yield GetAllDeliveryUsersFailedState();
      }
    } catch (e) {
      print(e);
      yield GetAllDeliveryUsersFailedState();
    }
  }
}
