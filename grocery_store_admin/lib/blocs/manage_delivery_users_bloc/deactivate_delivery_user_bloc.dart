import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/blocs/manage_delivery_users_bloc/all_delivery_users_bloc.dart';
import 'package:ecommerce_store_admin/models/delivery_user.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';

import 'manage_delivery_users_bloc.dart';

class DeactivateDeliveryUserBloc
    extends Bloc<ManageDeliveryUsersEvent, ManageDeliveryUsersState> {
  final UserDataRepository userDataRepository;

  DeactivateDeliveryUserBloc({this.userDataRepository}) : super(null);

  @override
  Stream<ManageDeliveryUsersState> mapEventToState(
    ManageDeliveryUsersEvent event,
  ) async* {
    if (event is DeactivateDeliveryUserEvent) {
      yield* mapDeactivateDeliveryUserEventToState(event.uid);
    }
    if (event is ActivateDeliveryUserEvent) {
      yield* mapActivateDeliveryUserEventToState(event.uid);
    }
  }

  Stream<ManageDeliveryUsersState> mapDeactivateDeliveryUserEventToState(
      String uid) async* {
    yield DeactivateDeliveryUserInProgressState();
    try {
      bool isDeactivated = await userDataRepository.deactivateDeliveryUser(uid);
      if (isDeactivated) {
        yield DeactivateDeliveryUserCompletedState();
      } else {
        yield DeactivateDeliveryUserFailedState();
      }
    } catch (e) {
      print(e);
      yield DeactivateDeliveryUserFailedState();
    }
  }

  Stream<ManageDeliveryUsersState> mapActivateDeliveryUserEventToState(
      String uid) async* {
    yield ActivateDeliveryUserInProgressState();
    try {
      bool isActivated = await userDataRepository.activateDeliveryUser(uid);
      if (isActivated) {
        yield ActivateDeliveryUserCompletedState();
      } else {
        yield ActivateDeliveryUserFailedState();
      }
    } catch (e) {
      print(e);
      yield ActivateDeliveryUserFailedState();
    }
  }
}
