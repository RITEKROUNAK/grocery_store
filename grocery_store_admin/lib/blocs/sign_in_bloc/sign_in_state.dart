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
  final User firebaseUser;

  SignInWithEmailEventCompletedState(this.firebaseUser);
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
  final bool isSignedIn;

  CheckIfSignedInEventCompletedState(this.isSignedIn);
  @override
  String toString() => 'FailedToCheckLoggedInState';
}

class GetCurrentUserFailedState extends SignInState {
  @override
  String toString() => 'GetCurrentUserFailedState';
}

class GetCurrentUserInProgressState extends SignInState {
  @override
  String toString() => 'GetCurrentUserInProgressState';
}

class GetCurrentUserCompletedState extends SignInState {
  final User firebaseUser;

  GetCurrentUserCompletedState(this.firebaseUser);

  @override
  String toString() => 'GetCurrentUserCompletedState';
}

class SignoutInProgressState extends SignInState {
  @override
  String toString() => 'SignoutInProgressState';
}

class SignoutCompletedState extends SignInState {
  @override
  String toString() => 'SignoutCompletedState';
}

class SignoutFailedState extends SignInState {
  @override
  String toString() => 'SignoutFailedState';
}

class CheckIfNewAdminInProgressState extends SignInState {
  @override
  String toString() => 'CheckIfNewAdminInProgressState';
}

class CheckIfNewAdminCompletedState extends SignInState {
  @override
  String toString() => 'CheckIfNewAdminCompletedState';
}

class CheckIfNewAdminFailedState extends SignInState {
  @override
  String toString() => 'CheckIfNewAdminFailedState';
}
