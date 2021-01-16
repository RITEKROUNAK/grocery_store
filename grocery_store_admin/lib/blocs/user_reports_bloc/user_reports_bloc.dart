import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/models/product.dart';
import 'package:ecommerce_store_admin/models/user_report.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

part 'user_reports_event.dart';
part 'user_reports_state.dart';

class UserReportsBloc extends Bloc<UserReportsEvent, UserReportsState> {
  final UserDataRepository userDataRepository;

  StreamSubscription userReportsSubscription;

  UserReportsBloc({@required this.userDataRepository}) : super(null);

  UserReportsState get initialState => UserReportsInitialState();

  @override
  Future<void> close() {
    print('Closing User Reports BLOC');
    userReportsSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<UserReportsState> mapEventToState(
    UserReportsEvent event,
  ) async* {
    if (event is LoadUserReportsEvent) {
      yield* mapLoadUserReportsEventToState();
    }
    if (event is UpdateUserReportsEvent) {
      yield* mapUpdateUserReportsEventToState(event.userReports);
    }
  }

  Stream<UserReportsState> mapLoadUserReportsEventToState() async* {
    yield LoadUserReportsInProgressState();

    try {
      userReportsSubscription?.cancel();
      userReportsSubscription =
          userDataRepository.getUserReports().listen((userReports) {
        add(UpdateUserReportsEvent(userReports));
      }, onError: (err) {
        print(err);
        return LoadUserReportsFailedState();
      });
    } catch (e) {
      print(e);
      yield LoadUserReportsFailedState();
    }
  }

  Stream<UserReportsState> mapUpdateUserReportsEventToState(
      List<UserReport> userReports) async* {
    yield LoadUserReportsCompletedState(userReports);
  }
}
