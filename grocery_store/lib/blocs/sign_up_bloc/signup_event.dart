part of 'signup_bloc.dart';

@immutable
abstract class SignupEvent {}

class SignupWithMobileNo extends SignupEvent {
  final String name;
  final String mobileNo;
  final String email;

  SignupWithMobileNo({
    @required this.name,
    @required this.mobileNo,
    @required this.email,
  });

  @override
  String toString() => 'SignupWithMobileEvent';
}

class SignupWithGoogle extends SignupEvent {
  @override
  String toString() => 'SignupWithGoogleEvent';
}

class VerifyMobileNo extends SignupEvent {
  final String otp;

  VerifyMobileNo(this.otp);

  @override
  String toString() => 'VerifyMobileNoEvent';
}

class SaveUserDetails extends SignupEvent {
  final String name;
  final String mobileNo;
  final String email;
  final User firebaseUser;
  final String loggedInVia;

  SaveUserDetails({
    @required this.name,
    @required this.mobileNo,
    @required this.email,
    @required this.firebaseUser,
    @required this.loggedInVia,
  });

  @override
  String toString() => 'SaveUserDetailsEvent';
}

class ResendCode extends SignupEvent {
  final String mobileNo;
  final String name;
  final String email;

  ResendCode({
    @required this.name,
    @required this.mobileNo,
    @required this.email,
  });

  @override
  String toString() => 'ResendCodeEvent';
}
