import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/models/product.dart';
import 'package:ecommerce_store_admin/models/user_report.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

import 'user_reports_bloc.dart';

class UserReportProductBloc extends Bloc<UserReportsEvent, UserReportsState> {
  final UserDataRepository userDataRepository;

  UserReportProductBloc({@required this.userDataRepository}) : super(null);

  UserReportsState get initialState => UserReportProductInitialState();

  @override
  Stream<UserReportsState> mapEventToState(
    UserReportsEvent event,
  ) async* {
    if (event is GetUserReportProductEvent) {
      yield* mapGetUserReportProductEventToState(event.id);
    }
  }

  Stream<UserReportsState> mapGetUserReportProductEventToState(
      String id) async* {
    yield GetUserReportProductInProgressState();

    try {
      Product product = await userDataRepository.getUserReportProduct(id);
      if (product != null) {
        yield GetUserReportProductCompletedState(product);
      } else {
        yield GetUserReportProductFailedState();
      }
    } catch (e) {
      print(e);
      yield GetUserReportProductFailedState();
    }
  }
}
