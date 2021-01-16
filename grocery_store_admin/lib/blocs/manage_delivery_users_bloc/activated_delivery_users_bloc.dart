import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/blocs/products_bloc/products_bloc.dart';
import 'package:ecommerce_store_admin/models/delivery_user.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

import 'manage_delivery_users_bloc.dart';

class ActivatedDeliveryUsersBloc
    extends Bloc<ManageDeliveryUsersEvent, ManageDeliveryUsersState> {
  final UserDataRepository userDataRepository;

  ActivatedDeliveryUsersBloc({this.userDataRepository}) : super(null);

  @override
  Stream<ManageDeliveryUsersState> mapEventToState(
    ManageDeliveryUsersEvent event,
  ) async* {
    if (event is GetActivatedDeliveryUsersEvent) {
      yield* mapGetActivatedDeliveryUsersEventToState();
    }
  }

  Stream<ManageDeliveryUsersState>
      mapGetActivatedDeliveryUsersEventToState() async* {
    yield GetActivatedDeliveryUsersInProgressState();
    try {
      List<DeliveryUser> deliveryUsers =
          await userDataRepository.getActivatedDeliveryUsers();
      if (deliveryUsers != null) {
        yield GetActivatedDeliveryUsersCompletedState(deliveryUsers);
      } else {
        yield GetActivatedDeliveryUsersFailedState();
      }
    } catch (e) {
      print(e);
      yield GetActivatedDeliveryUsersFailedState();
    }
  }
}
