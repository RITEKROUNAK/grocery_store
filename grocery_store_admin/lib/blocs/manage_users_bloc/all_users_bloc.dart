import 'package:ecommerce_store_admin/models/user.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'manage_users_bloc.dart';

class AllUsersBloc extends Bloc<ManageUsersEvent, ManageUsersState> {
  final UserDataRepository userDataRepository;

  AllUsersBloc({@required this.userDataRepository}) : super(null);

  ManageUsersState get initialState => AllUsersInitialState();

  @override
  Stream<ManageUsersState> mapEventToState(
    ManageUsersEvent event,
  ) async* {
    if (event is GetAllUsersManageUsersEvent) {
      yield* mapGetAllUsersManageUsersEventToState();
    }
  }

  Stream<ManageUsersState> mapGetAllUsersManageUsersEventToState() async* {
    yield GetAllUsersInProgressState();
    try {
      List<GroceryUser> users = await userDataRepository.getAllUsers();
      if (users != null) {
        yield GetAllUsersCompletedState(allUsers: users);
      } else {
        yield GetAllUsersFailedState();
      }
    } catch (e) {
      print(e);
      yield GetAllUsersFailedState();
    }
  }
}
