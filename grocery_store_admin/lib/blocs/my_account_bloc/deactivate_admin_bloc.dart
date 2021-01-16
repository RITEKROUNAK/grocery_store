import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/blocs/my_account_bloc/my_account_bloc.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';

class DeactivateAdminBloc extends Bloc<MyAccountEvent, MyAccountState> {
  final UserDataRepository userDataRepository;

  DeactivateAdminBloc({this.userDataRepository}) : super(null);

  @override
  Stream<MyAccountState> mapEventToState(
    MyAccountEvent event,
  ) async* {
    if (event is DeactivateAdminEvent) {
      yield* mapDeactivateAdminEventToState(event.uid);
    }
    if (event is ActivateAdminEvent) {
      yield* mapActivateAdminEventToState(event.uid);
    }
  }

  Stream<MyAccountState> mapDeactivateAdminEventToState(String uid) async* {
    yield DeactivateAdminInProgressState();
    try {
      bool isDeactivated = await userDataRepository.deactivateAdmin(uid);
      if (isDeactivated) {
        yield DeactivateAdminCompletedState();
      } else {
        yield DeactivateAdminFailedState();
      }
    } catch (e) {
      print(e);
      yield DeactivateAdminFailedState();
    }
  }

  Stream<MyAccountState> mapActivateAdminEventToState(String uid) async* {
    yield ActivateAdminInProgressState();
    try {
      bool isActivated = await userDataRepository.activateAdmin(uid);
      if (isActivated) {
        yield ActivateAdminCompletedState();
      } else {
        yield ActivateAdminFailedState();
      }
    } catch (e) {
      print(e);
      yield ActivateAdminFailedState();
    }
  }
}
