import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/models/admin.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

import 'my_account_bloc.dart';

class AllAdminsBloc extends Bloc<MyAccountEvent, MyAccountState> {
  final UserDataRepository userDataRepository;

  AllAdminsBloc({@required this.userDataRepository}) : super(null);

  MyAccountState get initialState => AllAdminsInitial();

  @override
  Stream<MyAccountState> mapEventToState(
    MyAccountEvent event,
  ) async* {
    if (event is GetAllAdminsEvent) {
      yield* mapGetAllAdminsEventToState();
    }
  }

  Stream<MyAccountState> mapGetAllAdminsEventToState() async* {
    yield GetAllAdminsInProgressState();
    try {
      List<Admin> admins = await userDataRepository.getAllAdmins();
      if (admins != null) {
        yield GetAllAdminsCompletedState(admins);
      } else {
        yield GetAllAdminsFailedState();
      }
    } catch (e) {
      print(e);
      yield GetAllAdminsFailedState();
    }
  }
}
