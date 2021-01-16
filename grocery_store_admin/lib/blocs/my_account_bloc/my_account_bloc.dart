import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/models/admin.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

part 'my_account_event.dart';
part 'my_account_state.dart';

class MyAccountBloc extends Bloc<MyAccountEvent, MyAccountState> {
  final UserDataRepository userDataRepository;

  MyAccountBloc({@required this.userDataRepository}) : super(null);

  MyAccountState get initialState => MyAccountInitial();

  @override
  Stream<MyAccountState> mapEventToState(
    MyAccountEvent event,
  ) async* {
    if (event is GetMyAccountDetailsEvent) {
      yield* mapGetMyAccountDetailsEventToState();
    }
    if (event is UpdateAdminDetailsEvent) {
      yield* mapUpdateAdminDetailsEventToState(event.adminMap);
    }
  }

  Stream<MyAccountState> mapGetMyAccountDetailsEventToState() async* {
    yield GetMyAccountDetailsInProgressState();
    try {
      Admin admin = await userDataRepository.getMyAccountDetails();
      if (admin != null) {
        yield GetMyAccountDetailsCompletedState(admin);
      } else {
        yield GetMyAccountDetailsFailedState();
      }
    } catch (e) {
      print(e);
      yield GetMyAccountDetailsFailedState();
    }
  }

  Stream<MyAccountState> mapUpdateAdminDetailsEventToState(
      Map adminMap) async* {
    yield UpdateAdminDetailsInProgressState();
    try {
      bool isUpdated = await userDataRepository.updateAdminDetails(adminMap);
      if (isUpdated) {
        yield UpdateAdminDetailsCompletedState();
      } else {
        yield UpdateAdminDetailsFailedState();
      }
    } catch (e) {
      print(e);
      yield UpdateAdminDetailsFailedState();
    }
  }
}
