import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'manage_delivery_users_bloc.dart';

class EditDeliveryUserBloc
    extends Bloc<ManageDeliveryUsersEvent, ManageDeliveryUsersState> {
  final UserDataRepository userDataRepository;

  EditDeliveryUserBloc({this.userDataRepository}) : super(null);

  @override
  Stream<ManageDeliveryUsersState> mapEventToState(
    ManageDeliveryUsersEvent event,
  ) async* {
    if (event is EditDeliveryUserEvent) {
      yield* mapEditDeliveryUserEventToState(event.deliveryUser);
    }
  }

  Stream<ManageDeliveryUsersState> mapEditDeliveryUserEventToState(
      Map deliveryUser) async* {
    yield EditDeliveryUserInProgressState();
    try {
      bool isEdited = await userDataRepository.editDeliveryUser(deliveryUser);
      if (isEdited) {
        yield EditDeliveryUserCompletedState();
      } else {
        yield EditDeliveryUserFailedState();
      }
    } catch (e) {
      print(e);
      yield EditDeliveryUserFailedState();
    }
  }
}
