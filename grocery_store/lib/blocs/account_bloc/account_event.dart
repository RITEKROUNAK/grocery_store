part of 'account_bloc.dart';

@immutable
abstract class AccountEvent {}

class GetAccountDetailsEvent extends AccountEvent {
  final String uid;
  GetAccountDetailsEvent(this.uid);

  @override
  String toString() => 'GetAccountDetailsEvent';
}

class AddAddressEvent extends AccountEvent {
  final List<Address> address;
  final String uid;
  final int defaultAddress;

  AddAddressEvent(this.address, this.uid, this.defaultAddress);

  @override
  String toString() => 'AddAddressEvent';
}

class EditAddressEvent extends AccountEvent {
  final List<Address> address;
  final String uid;
  final int defaultAddress;

  EditAddressEvent(this.address, this.uid, this.defaultAddress);

  @override
  String toString() => 'EditAddressEvent';
}

class RemoveAddressEvent extends AccountEvent {
  final List<Address> address;
  final String uid;
  final bool isDefault;

  RemoveAddressEvent(this.address, this.uid, this.isDefault);

  @override
  String toString() => 'RemoveAddressEvent';
}

class UpdateAccountDetailsEvent extends AccountEvent {
  final GroceryUser user;
  final File profileImage;

  UpdateAccountDetailsEvent({this.user, this.profileImage});

  @override
  String toString() => 'UpdateAccountDetailsEvent';
}
