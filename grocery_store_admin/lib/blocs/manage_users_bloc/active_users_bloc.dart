import 'package:ecommerce_store_admin/models/user.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'manage_users_bloc.dart';

class ActiveUsersBloc extends Bloc<ManageUsersEvent, ManageUsersState> {
  final UserDataRepository userDataRepository;

  ActiveUsersBloc({@required this.userDataRepository}) : super(null);

  ManageUsersState get initialState => ActiveUsersInitialState();

  @override
  Stream<ManageUsersState> mapEventToState(
    ManageUsersEvent event,
  ) async* {
    if (event is GetActiveUsersManageUsersEvent) {
      yield* mapGetActiveUsersManageUsersEventToState();
    }
  }

  Stream<ManageUsersState> mapGetActiveUsersManageUsersEventToState() async* {
    yield GetActiveUsersInProgressState();
    try {
      List<GroceryUser> users = await userDataRepository.getActiveUsers();
      if (users != null) {
        yield GetActiveUsersCompletedState(activeUsers: users);
      } else {
        yield GetActiveUsersFailedState();
      }
    } catch (e) {
      print(e);
      yield GetActiveUsersFailedState();
    }
  }
}
