import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/models/delivery_user.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';

import 'manage_delivery_users_bloc.dart';

class ReadyDeliveryUsersBloc
    extends Bloc<ManageDeliveryUsersEvent, ManageDeliveryUsersState> {
  final UserDataRepository userDataRepository;

  ReadyDeliveryUsersBloc({this.userDataRepository}) : super(null);

  @override
  Stream<ManageDeliveryUsersState> mapEventToState(
    ManageDeliveryUsersEvent event,
  ) async* {
    if (event is GetReadyDeliveryUsersEvent) {
      yield* mapGetReadyDeliveryUsersEventToState();
    }
  }

  Stream<ManageDeliveryUsersState>
      mapGetReadyDeliveryUsersEventToState() async* {
    yield GetReadyDeliveryUsersInProgressState();
    try {
      List<DeliveryUser> deliveryUsers =
          await userDataRepository.getReadyDeliveryUsers();
      if (deliveryUsers != null) {
        yield GetReadyDeliveryUsersCompletedState(deliveryUsers);
      } else {
        yield GetReadyDeliveryUsersFailedState();
      }
    } catch (e) {
      print(e);
      yield GetReadyDeliveryUsersFailedState();
    }
  }
}
