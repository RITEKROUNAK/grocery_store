part of 'sign_in_bloc.dart';

@immutable
abstract class SignInEvent {}

class SignInWithEmailEvent extends SignInEvent {
  final String email;
  final String password;

  SignInWithEmailEvent(this.email, this.password);
  @override
  String toString() => 'SignInWithEmailEvent';
}

class CheckIfSignedInEvent extends SignInEvent {
  @override
  String toString() => 'CheckIfSignedInEvent';
}

class SignOutEvent extends SignInEvent {
  @override
  String toString() => 'SignOutEvent';
}

class ChangePasswordEvent extends SignInEvent {
  final DeliveryUser user;

  ChangePasswordEvent(this.user);
  @override
  String toString() => 'ChangePasswordEvent';
}
