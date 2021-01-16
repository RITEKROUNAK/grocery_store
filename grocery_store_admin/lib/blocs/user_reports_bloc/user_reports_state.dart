part of 'user_reports_bloc.dart';

@immutable
abstract class UserReportsState {}

class UserReportsInitialState extends UserReportsState {}

class UserReportProductInitialState extends UserReportsState {}

class LoadUserReportsCompletedState extends UserReportsState {
  final List<UserReport> userReports;
  LoadUserReportsCompletedState(this.userReports);

  String toString() => 'LoadUserReportsCompletedState';
}

class LoadUserReportsFailedState extends UserReportsState {
  String toString() => 'LoadUserReportsFailedState';
}

class LoadUserReportsInProgressState extends UserReportsState {
  String toString() => 'LoadUserReportsInProgressState';
}

class GetUserReportProductCompletedState extends UserReportsState {
  final Product product;
  GetUserReportProductCompletedState(this.product);

  String toString() => 'GetUserReportProductCompletedState';
}

class GetUserReportProductFailedState extends UserReportsState {
  String toString() => 'GetUserReportProductFailedState';
}

class GetUserReportProductInProgressState extends UserReportsState {
  String toString() => 'GetUserReportProductInProgressState';
}
