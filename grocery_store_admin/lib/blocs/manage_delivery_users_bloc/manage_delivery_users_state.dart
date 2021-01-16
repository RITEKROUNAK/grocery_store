part of 'manage_delivery_users_bloc.dart';

@immutable
abstract class ManageDeliveryUsersState {}

class ManageDeliveryUsersInitial extends ManageDeliveryUsersState {}

class AddNewDeliveryUserInProgressState extends ManageDeliveryUsersState {
  @override
  String toString() => 'AddNewDeliveryUserInProgressState';
}

class AddNewDeliveryUserFailedState extends ManageDeliveryUsersState {
  @override
  String toString() => 'AddNewDeliveryUserFailedState';
}

class AddNewDeliveryUserCompletedState extends ManageDeliveryUsersState {
  @override
  String toString() => 'AddNewDeliveryUserCompletedState';
}

class EditDeliveryUserInProgressState extends ManageDeliveryUsersState {
  @override
  String toString() => 'EditDeliveryUserInProgressState';
}

class EditDeliveryUserFailedState extends ManageDeliveryUsersState {
  @override
  String toString() => 'EditDeliveryUserFailedState';
}

class EditDeliveryUserCompletedState extends ManageDeliveryUsersState {
  @override
  String toString() => 'EditDeliveryUserCompletedState';
}

class DeleteDeliveryUserInProgressState extends ManageDeliveryUsersState {
  @override
  String toString() => 'DeleteDeliveryUserInProgressState';
}

class DeleteDeliveryUserFailedState extends ManageDeliveryUsersState {
  @override
  String toString() => 'DeleteDeliveryUserFailedState';
}

class DeleteDeliveryUserCompletedState extends ManageDeliveryUsersState {
  @override
  String toString() => 'DeleteDeliveryUserCompletedState';
}

class GetDeliveryUserAnalyticsInProgressState extends ManageDeliveryUsersState {
  @override
  String toString() => 'GetDeliveryUserAnalyticsInProgressState';
}

class GetDeliveryUserAnalyticsFailedState extends ManageDeliveryUsersState {
  @override
  String toString() => 'GetDeliveryUserAnalyticsFailedState';
}

class GetDeliveryUserAnalyticsCompletedState extends ManageDeliveryUsersState {
  final DeliveryUserAnalytics deliveryUserAnalytics;

  GetDeliveryUserAnalyticsCompletedState(this.deliveryUserAnalytics);
  @override
  String toString() => 'GetDeliveryUserAnalyticsCompletedState';
}

class GetAllDeliveryUsersInProgressState extends ManageDeliveryUsersState {
  @override
  String toString() => 'GetAllDeliveryUsersInProgressState';
}

class GetAllDeliveryUsersFailedState extends ManageDeliveryUsersState {
  @override
  String toString() => 'GetAllDeliveryUsersFailedState';
}

class GetAllDeliveryUsersCompletedState extends ManageDeliveryUsersState {
  final List<DeliveryUser> deliveryUsers;

  GetAllDeliveryUsersCompletedState(this.deliveryUsers);
  @override
  String toString() => 'GetAllDeliveryUsersCompletedState';
}

class GetActiveDeliveryUsersInProgressState extends ManageDeliveryUsersState {
  @override
  String toString() => 'GetActiveDeliveryUsersInProgressState';
}

class GetActiveDeliveryUsersFailedState extends ManageDeliveryUsersState {
  @override
  String toString() => 'GetActiveDeliveryUsersFailedState';
}

class GetActiveDeliveryUsersCompletedState extends ManageDeliveryUsersState {
  final List<DeliveryUser> deliveryUsers;

  GetActiveDeliveryUsersCompletedState(this.deliveryUsers);
  @override
  String toString() => 'GetActiveDeliveryUsersCompletedState';
}

class GetInactiveDeliveryUsersInProgressState extends ManageDeliveryUsersState {
  @override
  String toString() => 'GetInactiveDeliveryUsersInProgressState';
}

class GetInactiveDeliveryUsersFailedState extends ManageDeliveryUsersState {
  @override
  String toString() => 'GetInactiveDeliveryUsersFailedState';
}

class GetInactiveDeliveryUsersCompletedState extends ManageDeliveryUsersState {
  final List<DeliveryUser> deliveryUsers;

  GetInactiveDeliveryUsersCompletedState(this.deliveryUsers);
  @override
  String toString() => 'GetInactiveDeliveryUsersCompletedState';
}

class GetActivatedDeliveryUsersInProgressState
    extends ManageDeliveryUsersState {
  @override
  String toString() => 'GetActivatedDeliveryUsersInProgressState';
}

class GetActivatedDeliveryUsersFailedState extends ManageDeliveryUsersState {
  @override
  String toString() => 'GetActivatedDeliveryUsersFailedState';
}

class GetActivatedDeliveryUsersCompletedState extends ManageDeliveryUsersState {
  final List<DeliveryUser> deliveryUsers;

  GetActivatedDeliveryUsersCompletedState(this.deliveryUsers);
  @override
  String toString() => 'GetActivatedDeliveryUsersCompletedState';
}

class GetDeactivatedDeliveryUsersInProgressState
    extends ManageDeliveryUsersState {
  @override
  String toString() => 'GetDeactivatedDeliveryUsersInProgressState';
}

class GetDeactivatedDeliveryUsersFailedState extends ManageDeliveryUsersState {
  @override
  String toString() => 'GetDeactivatedDeliveryUsersFailedState';
}

class GetDeactivatedDeliveryUsersCompletedState
    extends ManageDeliveryUsersState {
  final List<DeliveryUser> deliveryUsers;

  GetDeactivatedDeliveryUsersCompletedState(this.deliveryUsers);
  @override
  String toString() => 'GetDeactivatedDeliveryUsersCompletedState';
}

class DeactivateDeliveryUserInProgressState extends ManageDeliveryUsersState {
  @override
  String toString() => 'DeactivateDeliveryUserInProgressState';
}

class DeactivateDeliveryUserFailedState extends ManageDeliveryUsersState {
  @override
  String toString() => 'DeactivateDeliveryUserFailedState';
}

class DeactivateDeliveryUserCompletedState extends ManageDeliveryUsersState {
  @override
  String toString() => 'DeactivateDeliveryUserCompletedState';
}

class ActivateDeliveryUserInProgressState extends ManageDeliveryUsersState {
  @override
  String toString() => 'ActivateDeliveryUserInProgressState';
}

class ActivateDeliveryUserFailedState extends ManageDeliveryUsersState {
  @override
  String toString() => 'ActivateDeliveryUserFailedState';
}

class ActivateDeliveryUserCompletedState extends ManageDeliveryUsersState {
  @override
  String toString() => 'ActivateDeliveryUserCompletedState';
}

class GetReadyDeliveryUsersInProgressState extends ManageDeliveryUsersState {
  @override
  String toString() => 'GetReadyDeliveryUsersInProgressState';
}

class GetReadyDeliveryUsersFailedState extends ManageDeliveryUsersState {
  @override
  String toString() => 'GetReadyDeliveryUsersFailedState';
}

class GetReadyDeliveryUsersCompletedState extends ManageDeliveryUsersState {
  final List<DeliveryUser> deliveryUsers;

  GetReadyDeliveryUsersCompletedState(this.deliveryUsers);
  @override
  String toString() => 'GetReadyDeliveryUsersCompletedState';
}
