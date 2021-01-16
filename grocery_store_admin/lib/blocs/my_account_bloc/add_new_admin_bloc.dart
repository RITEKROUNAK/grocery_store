import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/models/admin.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

import 'my_account_bloc.dart';

class AddNewAdminBloc extends Bloc<MyAccountEvent, MyAccountState> {
  final UserDataRepository userDataRepository;

  AddNewAdminBloc({@required this.userDataRepository}) : super(null);

  MyAccountState get initialState => AddNewAdminInitial();

  @override
  Stream<MyAccountState> mapEventToState(
    MyAccountEvent event,
  ) async* {
    if (event is AddNewAdminEvent) {
      yield* mapAddNewAdminEventToState(event.adminMap);
    }
  }

  Stream<MyAccountState> mapAddNewAdminEventToState(Map adminMap) async* {
    yield AddNewAdminInProgressState();
    try {
      bool isAdded = await userDataRepository.addNewAdmin(adminMap);
      if (isAdded) {
        yield AddNewAdminCompletedState();
      } else {
        yield AddNewAdminFailedState();
      }
    } catch (e) {
      print(e);
      yield AddNewAdminFailedState();
    }
  }
}
