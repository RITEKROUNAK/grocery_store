import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/models/admin.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

import 'my_account_bloc.dart';

class EditAdminBloc extends Bloc<MyAccountEvent, MyAccountState> {
  final UserDataRepository userDataRepository;

  EditAdminBloc({@required this.userDataRepository}) : super(null);

  MyAccountState get initialState => EditAdminInitial();

  @override
  Stream<MyAccountState> mapEventToState(
    MyAccountEvent event,
  ) async* {
    if (event is EditAdminEvent) {
      yield* mapEditAdminEventToState(event.adminMap);
    }
  }

  Stream<MyAccountState> mapEditAdminEventToState(Map adminMap) async* {
    yield EditAdminInProgressState();
    try {
      bool isAdded = await userDataRepository.updateAdminDetails(adminMap);
      if (isAdded) {
        yield EditAdminCompletedState();
      } else {
        yield EditAdminFailedState();
      }
    } catch (e) {
      print(e);
      yield EditAdminFailedState();
    }
  }
}
