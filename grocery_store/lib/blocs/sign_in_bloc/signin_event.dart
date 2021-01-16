part of 'signin_bloc.dart';

@immutable
abstract class SigninEvent {}

class SignInWithGoogle extends SigninEvent {
  @override
  String toString() => 'SignInWithGoogleEvent';
}

class SignInWithMobileNo extends SigninEvent {
  final String mobileNo;

  SignInWithMobileNo(this.mobileNo);
  @override
  String toString() => 'SignInWithGoogleEvent';
}

class VerifyMobileNo extends SigninEvent {
  final String otp;

  VerifyMobileNo(this.otp);
  @override
  String toString() => 'VerifyMobileNoEvent';
}

class CheckIfSignedIn extends SigninEvent {
  @override
  String toString() => 'CheckIfSignedInEvent';
}

class GetCurrentUser extends SigninEvent {
  @override
  String toString() => 'GetCurrentUserEvent';
}

class SignoutEvent extends SigninEvent {
  @override
  String toString() => 'SignoutEvent';
}

class CheckIfBlocked extends SigninEvent {
  final String mobileNo;

  CheckIfBlocked(this.mobileNo);
  @override
  String toString() => 'CheckIfBlockedEvent';
}
