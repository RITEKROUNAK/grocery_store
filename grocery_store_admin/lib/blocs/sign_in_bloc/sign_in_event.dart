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

class GetCurrentUserEvent extends SignInEvent {
  @override
  String toString() => 'GetCurrentUserEvent';
}

class SignoutEvent extends SignInEvent {
  @override
  String toString() => 'SignoutEvent';
}

class CheckIfNewAdminEvent extends SignInEvent {
  final String uid;

  CheckIfNewAdminEvent(this.uid);
  @override
  String toString() => 'CheckIfNewAdminEvent';
}
