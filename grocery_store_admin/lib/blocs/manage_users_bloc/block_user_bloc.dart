import 'package:ecommerce_store_admin/models/user.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'manage_users_bloc.dart';

class BlockUserBloc extends Bloc<ManageUsersEvent, ManageUsersState> {
  final UserDataRepository userDataRepository;

  BlockUserBloc({@required this.userDataRepository}) : super(null);

  ManageUsersState get initialState => BlockUserInitialState();

  @override
  Stream<ManageUsersState> mapEventToState(
    ManageUsersEvent event,
  ) async* {
    if (event is BlockUserManageUsersEvent) {
      yield* mapBlockUserManageUsersEventToState(event.uid);
    }
    if (event is UnblockUserManageUsersEvent) {
      yield* mapUnblockUserManageUsersEventToState(event.uid);
    }
  }

  Stream<ManageUsersState> mapBlockUserManageUsersEventToState(
      String uid) async* {
    yield BlockUserInProgressState();
    try {
      bool isBlocked = await userDataRepository.blockUser(uid);
      if (isBlocked) {
        yield BlockUserCompletedState();
      } else {
        yield BlockUserFailedState();
      }
    } catch (e) {
      print(e);
      yield BlockUserFailedState();
    }
  }

  Stream<ManageUsersState> mapUnblockUserManageUsersEventToState(
      String uid) async* {
    yield BlockUserInProgressState();
    try {
      bool isUnblocked = await userDataRepository.unblockUser(uid);
      if (isUnblocked) {
        yield BlockUserCompletedState();
      } else {
        yield BlockUserFailedState();
      }
    } catch (e) {
      print(e);
      yield BlockUserFailedState();
    }
  }
}
