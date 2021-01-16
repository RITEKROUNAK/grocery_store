part of 'signin_bloc.dart';

@immutable
abstract class SigninState {}

class SigninInitial extends SigninState {
  @override
  String toString() => 'SignInIntialState';
}

class SignInWithGoogleInProgress extends SigninState {
  @override
  String toString() => 'SignInWithGoogleInProgressState';
}

class SignInWithMobileNoInProgress extends SigninState {
  @override
  String toString() => 'SignInWithMobileNoInProgressState';
}

class SigninWithGoogleCompleted extends SigninState {
  final String result;
  SigninWithGoogleCompleted(this.result);

  @override
  String toString() => 'SigninWithGoogleCompletedState';
}

class SigninWithMobileNoCompleted extends SigninState {
  @override
  String toString() => 'SigninWithMobileNoCompletedState';
}

class SigninWithGoogleFailed extends SigninState {
  @override
  String toString() => 'SigninWithGoogleFailedState';
}

class SigninWithMobileNoFailed extends SigninState {
  @override
  String toString() => 'SigninWithMobileNoFailedState';
}

class VerifyMobileNoInProgress extends SigninState {
  @override
  String toString() => 'VerifyMobileNoInProgressState';
}

class VerifyMobileNoCompleted extends SigninState {
  final User firebaseUser;
  VerifyMobileNoCompleted(this.firebaseUser);

  @override
  String toString() => 'VerifyMobileNoCompletedState';
}

class VerifyMobileNoFailed extends SigninState {
  @override
  String toString() => 'VerifyMobileNoFailedState';
}

class NotSignedupWithMobileNo extends SigninState {
  @override
  String toString() => 'NotSignedupWithMobileNoState';
}

class NotSignedupWithGoogle extends SigninState {
  @override
  String toString() => 'NotSignedupWithGoogleState';
}

class LoggedIn extends SigninState {
  @override
  String toString() => 'LoggedInState';
}

class NotLoggedIn extends SigninState {
  @override
  String toString() => 'NotLoggedInState';
}

class FailedToCheckLoggedIn extends SigninState {
  @override
  String toString() => 'FailedToCheckLoggedInState';
}

class CheckIfSignedInCompleted extends SigninState {
  final String res;

  CheckIfSignedInCompleted(this.res);
  @override
  String toString() => 'CheckIfSignedInCompleted';
}

class GetCurrentUserFailed extends SigninState {
  @override
  String toString() => 'GetCurrentUserFailedState';
}

class GetCurrentUserInProgress extends SigninState {
  @override
  String toString() => 'GetCurrentUserInProgressState';
}

class GetCurrentUserCompleted extends SigninState {
  final User firebaseUser;
  GetCurrentUserCompleted(this.firebaseUser);

  @override
  String toString() => 'GetCurrentUserCompletedState';
}

class SignoutInProgress extends SigninState {
  @override
  String toString() => 'SignoutInProgressState';
}

class SignoutCompleted extends SigninState {
  @override
  String toString() => 'SignoutCompletedState';
}

class SignoutFailed extends SigninState {
  @override
  String toString() => 'SignoutFailedState';
}

class CheckIfBlockedInProgress extends SigninState {
  @override
  String toString() => 'CheckIfBlockedInProgressState';
}

class CheckIfBlockedCompleted extends SigninState {
  final String result;

  CheckIfBlockedCompleted(this.result);
  @override
  String toString() => 'CheckIfBlockedCompletedState';
}

class CheckIfBlockedFailed extends SigninState {
  @override
  String toString() => 'CheckIfBlockedFailedState';
}
