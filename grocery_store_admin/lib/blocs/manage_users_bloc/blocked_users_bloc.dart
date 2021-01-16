import 'package:ecommerce_store_admin/models/user.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'manage_users_bloc.dart';

class BlockedUsersBloc extends Bloc<ManageUsersEvent, ManageUsersState> {
  final UserDataRepository userDataRepository;

  BlockedUsersBloc({@required this.userDataRepository}) : super(null);

  ManageUsersState get initialState => BlockedUsersInitialState();

  @override
  Stream<ManageUsersState> mapEventToState(
    ManageUsersEvent event,
  ) async* {
    if (event is GetBlockedUsersManageUsersEvent) {
      yield* mapGetBlockedUsersManageUsersEventToState();
    }
  }

  Stream<ManageUsersState> mapGetBlockedUsersManageUsersEventToState() async* {
    yield GetBlockedUsersInProgressState();
    try {
      List<GroceryUser> users = await userDataRepository.getBlockedUsers();
      if (users != null) {
        yield GetBlockedUsersCompletedState(blockedUsers: users);
      } else {
        yield GetBlockedUsersFailedState();
      }
    } catch (e) {
      print(e);
      yield GetBlockedUsersFailedState();
    }
  }
}
