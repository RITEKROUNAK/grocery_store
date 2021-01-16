part of 'manage_users_bloc.dart';

@immutable
abstract class ManageUsersState {}

class ManageUsersInitialState extends ManageUsersState {
  @override
  String toString() => 'ManageUsersInitialState';
}

class UsersOrderInitialState extends ManageUsersState {
  @override
  String toString() => 'UsersOrderInitialState';
}

class AllUsersInitialState extends ManageUsersState {
  @override
  String toString() => 'AllUsersInitialState';
}

class ActiveUsersInitialState extends ManageUsersState {
  @override
  String toString() => 'ActiveUsersInitialState';
}

class InactiveUsersInitialState extends ManageUsersState {
  @override
  String toString() => 'InactiveUsersInitialState';
}

class BlockedUsersInitialState extends ManageUsersState {
  @override
  String toString() => 'BlockedUsersInitialState';
}

class BlockUserInitialState extends ManageUsersState {
  @override
  String toString() => 'BlockUserInitialState';
}

class GetUserAnalyticsCompletedState extends ManageUsersState {
  final UserAnalytics userAnalytics;

  GetUserAnalyticsCompletedState({
    @required this.userAnalytics,
  });

  String toString() => 'GetUserAnalyticsCompletedState';
}

class GetUserAnalyticsFailedState extends ManageUsersState {
  String toString() => 'GetUserAnalyticsFailedState';
}

class GetUserAnalyticsInProgressState extends ManageUsersState {
  String toString() => 'GetUserAnalyticsInProgressState';
}

class GetAllUsersInProgressState extends ManageUsersState {
  @override
  String toString() => 'GetAllUsersInProgressState';
}

class GetAllUsersFailedState extends ManageUsersState {
  @override
  String toString() => 'GetAllUsersFailedState';
}

class GetAllUsersCompletedState extends ManageUsersState {
  final List<GroceryUser> allUsers;

  GetAllUsersCompletedState({
    @required this.allUsers,
  });

  @override
  String toString() => 'GetAllUsersCompletedState';
}

class GetActiveUsersInProgressState extends ManageUsersState {
  @override
  String toString() => 'GetActiveUsersInProgressState';
}

class GetActiveUsersFailedState extends ManageUsersState {
  @override
  String toString() => 'GetActiveUsersFailedState';
}

class GetActiveUsersCompletedState extends ManageUsersState {
  final List<GroceryUser> activeUsers;

  GetActiveUsersCompletedState({
    @required this.activeUsers,
  });

  @override
  String toString() => 'GetActiveUsersCompletedState';
}

class GetInactiveUsersInProgressState extends ManageUsersState {
  @override
  String toString() => 'GetInactiveUsersInProgressState';
}

class GetInactiveUsersFailedState extends ManageUsersState {
  @override
  String toString() => 'GetInactiveUsersFailedState';
}

class GetInactiveUsersCompletedState extends ManageUsersState {
  final List<GroceryUser> inactiveUsers;

  GetInactiveUsersCompletedState({
    @required this.inactiveUsers,
  });

  @override
  String toString() => 'GetInactiveUsersCompletedState';
}

class GetBlockedUsersInProgressState extends ManageUsersState {
  @override
  String toString() => 'GetBlockedUsersInProgressState';
}

class GetBlockedUsersFailedState extends ManageUsersState {
  @override
  String toString() => 'GetBlockedUsersFailedState';
}

class GetBlockedUsersCompletedState extends ManageUsersState {
  final List<GroceryUser> blockedUsers;

  GetBlockedUsersCompletedState({
    @required this.blockedUsers,
  });

  @override
  String toString() => 'GetBlockedUsersCompletedState';
}

class GetUsersOrderInProgressState extends ManageUsersState {
  @override
  String toString() => 'GetUsersOrderInProgressState';
}

class GetUsersOrderFailedState extends ManageUsersState {
  @override
  String toString() => 'GetUsersOrderFailedState';
}

class GetUsersOrderCompletedState extends ManageUsersState {
  final List<Order> orders;

  GetUsersOrderCompletedState({
    @required this.orders,
  });

  @override
  String toString() => 'GetUsersOrderCompletedState';
}

class BlockUserInProgressState extends ManageUsersState {
  @override
  String toString() => 'BlockUserInProgressState';
}

class BlockUserFailedState extends ManageUsersState {
  @override
  String toString() => 'BlockUserFailedState';
}

class BlockUserCompletedState extends ManageUsersState {
  @override
  String toString() => 'BlockUserCompletedState';
}

class UnblockUserInProgressState extends ManageUsersState {
  @override
  String toString() => 'UnblockUserInProgressState';
}

class UnblockUserFailedState extends ManageUsersState {
  @override
  String toString() => 'UnblockUserFailedState';
}

class UnblockUserCompletedState extends ManageUsersState {
  @override
  String toString() => 'UnblockUserCompletedState';
}
