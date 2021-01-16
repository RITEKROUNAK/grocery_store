part of 'user_reports_bloc.dart';

@immutable
abstract class UserReportsEvent {}

class LoadUserReportsEvent extends UserReportsEvent {
  @override
  String toString() => 'LoadUserReportsEvent';
}

class UpdateUserReportsEvent extends UserReportsEvent {
  final List<UserReport> userReports;

  UpdateUserReportsEvent(this.userReports);

  @override
  String toString() => 'UpdateUserReportsEvent';
}

class GetUserReportProductEvent extends UserReportsEvent {
  final String id;

  GetUserReportProductEvent(this.id);
  @override
  String toString() => 'GetUserReportProductEvent';
}
