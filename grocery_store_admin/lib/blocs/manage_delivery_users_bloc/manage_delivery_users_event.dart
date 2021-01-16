part of 'manage_delivery_users_bloc.dart';

@immutable
abstract class ManageDeliveryUsersEvent {}

class AddNewDeliveryUserEvent extends ManageDeliveryUsersEvent {
  final Map deliveryUser;

  AddNewDeliveryUserEvent(this.deliveryUser);
  @override
  String toString() => 'AddNewDeliveryUserEvent';
}

class EditDeliveryUserEvent extends ManageDeliveryUsersEvent {
  final Map deliveryUser;

  EditDeliveryUserEvent(this.deliveryUser);
  @override
  String toString() => 'EditDeliveryUserEvent';
}

class DeleteDeliveryUserEvent extends ManageDeliveryUsersEvent {
  final String uid;

  DeleteDeliveryUserEvent(this.uid);
  @override
  String toString() => 'DeleteDeliveryUserEvent';
}

class GetDeliveryUserAnalyticsEvent extends ManageDeliveryUsersEvent {
  @override
  String toString() => 'GetDeliveryUserAnalyticsEvent';
}

class UpdateDeliveryUserAnalyticsEvent extends ManageDeliveryUsersEvent {
  final DeliveryUserAnalytics deliveryUserAnalytics;

  UpdateDeliveryUserAnalyticsEvent(this.deliveryUserAnalytics);
  @override
  String toString() => 'UpdateDeliveryUserAnalyticsEvent';
}

class GetAllDeliveryUsersEvent extends ManageDeliveryUsersEvent {
  @override
  String toString() => 'GetAllDeliveryUsersEvent';
}

class GetActiveDeliveryUsersEvent extends ManageDeliveryUsersEvent {
  @override
  String toString() => 'GetActiveDeliveryUsersEvent';
}

class GetInactiveDeliveryUsersEvent extends ManageDeliveryUsersEvent {
  @override
  String toString() => 'GetInactiveDeliveryUsersEvent';
}

class GetActivatedDeliveryUsersEvent extends ManageDeliveryUsersEvent {
  @override
  String toString() => 'GetActivatedDeliveryUsersEvent';
}

class GetDeactivatedDeliveryUsersEvent extends ManageDeliveryUsersEvent {
  @override
  String toString() => 'GetDeactivatedDeliveryUsersEvent';
}

class DeactivateDeliveryUserEvent extends ManageDeliveryUsersEvent {
  final String uid;

  DeactivateDeliveryUserEvent(this.uid);
  @override
  String toString() => 'DeactivateDeliveryUserEvent';
}

class ActivateDeliveryUserEvent extends ManageDeliveryUsersEvent {
  final String uid;

  ActivateDeliveryUserEvent(this.uid);
  @override
  String toString() => 'ActivateDeliveryUserEvent';
}

class GetReadyDeliveryUsersEvent extends ManageDeliveryUsersEvent {
  @override
  String toString() => 'GetReadyDeliveryUsersEvent';
}
