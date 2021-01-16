part of 'my_account_bloc.dart';

@immutable
abstract class MyAccountState {}

class MyAccountInitial extends MyAccountState {}

class AllAdminsInitial extends MyAccountState {}

class AddNewAdminInitial extends MyAccountState {}

class EditAdminInitial extends MyAccountState {}

class GetMyAccountDetailsCompletedState extends MyAccountState {
  final Admin admin;
  GetMyAccountDetailsCompletedState(this.admin);

  String toString() => 'GetMyAccountDetailsCompletedState';
}

class GetMyAccountDetailsFailedState extends MyAccountState {
  String toString() => 'GetMyAccountDetailsFailedState';
}

class GetMyAccountDetailsInProgressState extends MyAccountState {
  String toString() => 'GetMyAccountDetailsInProgressState';
}

class GetAllAdminsCompletedState extends MyAccountState {
  final List<Admin> admins;
  GetAllAdminsCompletedState(this.admins);

  String toString() => 'GetAllAdminsCompletedState';
}

class GetAllAdminsFailedState extends MyAccountState {
  String toString() => 'GetAllAdminsFailedState';
}

class GetAllAdminsInProgressState extends MyAccountState {
  String toString() => 'GetAllAdminsInProgressState';
}

class UpdateAdminDetailsCompletedState extends MyAccountState {
  String toString() => 'UpdateAdminDetailsCompletedState';
}

class UpdateAdminDetailsFailedState extends MyAccountState {
  String toString() => 'UpdateAdminDetailsFailedState';
}

class UpdateAdminDetailsInProgressState extends MyAccountState {
  String toString() => 'UpdateAdminDetailsInProgressState';
}

class AddNewAdminCompletedState extends MyAccountState {
  String toString() => 'AddNewAdminCompletedState';
}

class AddNewAdminFailedState extends MyAccountState {
  String toString() => 'AddNewAdminFailedState';
}

class AddNewAdminInProgressState extends MyAccountState {
  String toString() => 'AddNewAdminInProgressState';
}

class EditAdminCompletedState extends MyAccountState {
  String toString() => 'EditAdminCompletedState';
}

class EditAdminFailedState extends MyAccountState {
  String toString() => 'EditAdminFailedState';
}

class EditAdminInProgressState extends MyAccountState {
  String toString() => 'EditAdminInProgressState';
}

class DeactivateAdminInProgressState extends MyAccountState {
  @override
  String toString() => 'DeactivateAdminInProgressState';
}

class DeactivateAdminFailedState extends MyAccountState {
  @override
  String toString() => 'DeactivateAdminFailedState';
}

class DeactivateAdminCompletedState extends MyAccountState {
  @override
  String toString() => 'DeactivateAdminCompletedState';
}

class ActivateAdminInProgressState extends MyAccountState {
  @override
  String toString() => 'ActivateAdminInProgressState';
}

class ActivateAdminFailedState extends MyAccountState {
  @override
  String toString() => 'ActivateAdminFailedState';
}

class ActivateAdminCompletedState extends MyAccountState {
  @override
  String toString() => 'ActivateAdminCompletedState';
}
