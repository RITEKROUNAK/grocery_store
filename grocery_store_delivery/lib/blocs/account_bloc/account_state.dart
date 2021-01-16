part of 'account_bloc.dart';

@immutable
abstract class AccountState {}

class AccountInitial extends AccountState {}

class GetAccountDetailsInProgressState extends AccountState {
  @override
  String toString() => 'GetAccountDetailsInProgressState';
}

class GetAccountDetailsFailedState extends AccountState {
  @override
  String toString() => 'GetAccountDetailsFailedState';
}

class GetAccountDetailsCompletedState extends AccountState {
  final DeliveryUser user;

  GetAccountDetailsCompletedState(this.user);

  @override
  String toString() => 'GetAccountDetailsCompletedState';
}

class AddAddressInProgressState extends AccountState {
  @override
  String toString() => 'AddAddressInProgressState';
}

class AddAddressFailedState extends AccountState {
  @override
  String toString() => 'AddAddressFailedState';
}

class AddAddressCompletedState extends AccountState {
  @override
  String toString() => 'AddAddressCompletedState';
}

class RemoveAddressInProgressState extends AccountState {
  @override
  String toString() => 'RemoveAddressInProgressState';
}

class RemoveAddressFailedState extends AccountState {
  @override
  String toString() => 'RemoveAddressFailedState';
}

class RemoveAddressCompletedState extends AccountState {
  @override
  String toString() => 'RemoveAddressCompletedState';
}

class EditAddressInProgressState extends AccountState {
  @override
  String toString() => 'EditAddressInProgressState';
}

class EditAddressFailedState extends AccountState {
  @override
  String toString() => 'EditAddressFailedState';
}

class EditAddressCompletedState extends AccountState {
  @override
  String toString() => 'EditAddressCompletedState';
}

class UpdateAccountDetailsInProgressState extends AccountState {
  @override
  String toString() => 'UpdateAccountDetailsInProgressState';
}

class UpdateAccountDetailsFailedState extends AccountState {
  @override
  String toString() => 'UpdateAccountDetailsFailedState';
}

class UpdateAccountDetailsCompletedState extends AccountState {
  @override
  String toString() => 'UpdateAccountDetailsCompletedState';
}
