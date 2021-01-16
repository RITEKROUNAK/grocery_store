part of 'my_account_bloc.dart';

@immutable
abstract class MyAccountEvent {}

class GetMyAccountDetailsEvent extends MyAccountEvent {
  @override
  String toString() => 'GetMyAccountDetailsEvent';
}

class GetAllAdminsEvent extends MyAccountEvent {
  @override
  String toString() => 'GetAllAdminsEvent';
}

class UpdateAdminDetailsEvent extends MyAccountEvent {
  final Map adminMap;

  UpdateAdminDetailsEvent(this.adminMap);
  @override
  String toString() => 'UpdateAdminDetailsEvent';
}

class AddNewAdminEvent extends MyAccountEvent {
  final Map adminMap;

  AddNewAdminEvent(this.adminMap);
  @override
  String toString() => 'AddNewAdminEvent';
}

class EditAdminEvent extends MyAccountEvent {
  final Map adminMap;

  EditAdminEvent(this.adminMap);

  @override
  String toString() => 'EditAdminEvent';
}

class DeactivateAdminEvent extends MyAccountEvent {
  final String uid;

  DeactivateAdminEvent(this.uid);
  @override
  String toString() => 'DeactivateAdminEvent';
}

class ActivateAdminEvent extends MyAccountEvent {
  final String uid;

  ActivateAdminEvent(this.uid);
  @override
  String toString() => 'ActivateAdminEvent';
}
