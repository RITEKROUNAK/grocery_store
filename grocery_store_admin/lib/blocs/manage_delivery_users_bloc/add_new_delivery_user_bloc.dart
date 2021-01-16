import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/blocs/products_bloc/products_bloc.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

import 'manage_delivery_users_bloc.dart';

class AddNewDeliveryUserBloc
    extends Bloc<ManageDeliveryUsersEvent, ManageDeliveryUsersState> {
  final UserDataRepository userDataRepository;

  AddNewDeliveryUserBloc({this.userDataRepository}) : super(null);

  @override
  Stream<ManageDeliveryUsersState> mapEventToState(
    ManageDeliveryUsersEvent event,
  ) async* {
    if (event is AddNewDeliveryUserEvent) {
      yield* mapAddNewDeliveryUserEventToState(event.deliveryUser);
    }
  }

  Stream<ManageDeliveryUsersState> mapAddNewDeliveryUserEventToState(
      Map deliveryUser) async* {
    yield AddNewDeliveryUserInProgressState();
    try {
      bool isAdded = await userDataRepository.addNewDeliveryUser(deliveryUser);
      if (isAdded) {
        yield AddNewDeliveryUserCompletedState();
      } else {
        yield AddNewDeliveryUserFailedState();
      }
    } catch (e) {
      print(e);
      yield AddNewDeliveryUserFailedState();
    }
  }
}
