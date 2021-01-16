part of 'manage_users_bloc.dart';

@immutable
abstract class ManageUsersEvent {}

class GetUserAnalyticsEvent extends ManageUsersEvent {
  String toString() => 'GetUserAnalyticsEvent';
}

class UpdateUserAnalyticsEvent extends ManageUsersEvent {
  final UserAnalytics userAnalytics;

  UpdateUserAnalyticsEvent({@required this.userAnalytics});

  @override
  String toString() => 'UpdateUserAnalyticsEvent';
}

class GetAllUsersManageUsersEvent extends ManageUsersEvent {
  @override
  String toString() => 'GetAllUsersManageUsersEvent';
}

class GetActiveUsersManageUsersEvent extends ManageUsersEvent {
  @override
  String toString() => 'GetActiveUsersManageUsersEvent';
}

class GetInactiveUsersManageUsersEvent extends ManageUsersEvent {
  @override
  String toString() => 'GetInactiveUsersManageUsersEvent';
}

class GetBlockedUsersManageUsersEvent extends ManageUsersEvent {
  @override
  String toString() => 'GetBlockedUsersManageUsersEvent';
}

class GetUsersOrderManageUsersEvent extends ManageUsersEvent {
  final List<dynamic> orderIds;

  GetUsersOrderManageUsersEvent(this.orderIds);

  @override
  String toString() => 'GetUsersOrderManageUsersEvent';
}

class BlockUserManageUsersEvent extends ManageUsersEvent {
  final String uid;

  BlockUserManageUsersEvent(this.uid);

  @override
  String toString() => 'BlockUserManageUsersEvent';
}

class UnblockUserManageUsersEvent extends ManageUsersEvent {
  final String uid;

  UnblockUserManageUsersEvent(this.uid);

  @override
  String toString() => 'UnblockUserManageUsersEvent';
}
