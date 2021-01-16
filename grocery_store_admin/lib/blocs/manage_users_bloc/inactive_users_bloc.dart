import 'package:ecommerce_store_admin/models/user.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'manage_users_bloc.dart';

class InactiveUsersBloc extends Bloc<ManageUsersEvent, ManageUsersState> {
  final UserDataRepository userDataRepository;

  InactiveUsersBloc({@required this.userDataRepository}) : super(null);

  ManageUsersState get initialState => InactiveUsersInitialState();

  @override
  Stream<ManageUsersState> mapEventToState(
    ManageUsersEvent event,
  ) async* {
    if (event is GetInactiveUsersManageUsersEvent) {
      yield* mapGetInactiveUsersManageUsersEventToState();
    }
  }

  Stream<ManageUsersState> mapGetInactiveUsersManageUsersEventToState() async* {
    yield GetInactiveUsersInProgressState();
    try {
      List<GroceryUser> users = await userDataRepository.getInactiveUsers();
      if (users != null) {
        yield GetInactiveUsersCompletedState(inactiveUsers: users);
      } else {
        yield GetInactiveUsersFailedState();
      }
    } catch (e) {
      print(e);
      yield GetInactiveUsersFailedState();
    }
  }
}
