part of 'sign_in_bloc.dart';

@immutable
abstract class SignInState {}

class SignInInitial extends SignInState {}

class SignInWithEmailEventInProgressState extends SignInState {
  @override
  String toString() => 'SignInWithEmailEventInProgressState';
}

class SignInWithEmailEventFailedState extends SignInState {
  @override
  String toString() => 'SignInWithEmailEventFailedState';
}

class SignInWithEmailEventCompletedState extends SignInState {
  final String res;

  SignInWithEmailEventCompletedState(this.res);
  @override
  String toString() => 'SignInWithEmailEventCompletedState';
}

class CheckIfSignedInEventInProgressState extends SignInState {
  @override
  String toString() => 'CheckIfSignedInEventInProgressState';
}

class CheckIfSignedInEventFailedState extends SignInState {
  @override
  String toString() => 'CheckIfSignedInEventFailedState';
}

class CheckIfSignedInEventCompletedState extends SignInState {
  final String res;

  CheckIfSignedInEventCompletedState(this.res);
  @override
  String toString() => 'FailedToCheckLoggedInState';
}

class SignOutEventInProgressState extends SignInState {
  @override
  String toString() => 'SignOutEventInProgressState';
}

class SignOutEventFailedState extends SignInState {
  @override
  String toString() => 'SignOutEventFailedState';
}

class SignOutEventCompletedState extends SignInState {
  @override
  String toString() => 'SignOutEventCompletedState';
}

class ChangePasswordEventInProgressState extends SignInState {
  @override
  String toString() => 'ChangePasswordEventInProgressState';
}

class ChangePasswordEventFailedState extends SignInState {
  @override
  String toString() => 'ChangePasswordEventFailedState';
}

class ChangePasswordEventCompletedState extends SignInState {
  @override
  String toString() => 'ChangePasswordEventCompletedState';
}
