part of 'signup_bloc.dart';

@immutable
abstract class SignupState {}

class SignupInitial extends SignupState {
  @override
  String toString() => 'SignupInitialState';
}

class SignUpInProgress extends SignupState {
  @override
  String toString() => 'SignUpInProgressState';
}

class SignupWithGoogleInitialCompleted extends SignupState {
  final User firebaseUser;

  SignupWithGoogleInitialCompleted(this.firebaseUser);

  @override
  String toString() => 'SignupWithGoogleInitialCompletedState';
}

class SignupWithGoogleInitialFailed extends SignupState {
  @override
  String toString() => 'SignupWithGoogleInitialFailedState';
}

class SignupWithMobileCompleted extends SignupState {
  final String mobileNo;

  SignupWithMobileCompleted({@required this.mobileNo});

  @override
  String toString() => 'SignupWithMobileCompletedState';
}

class VerificationInProgress extends SignupState {
  @override
  String toString() => 'VerificationInProgressState';
}

class VerificationFailed extends SignupState {
  @override
  String toString() => 'VerificationInFailedState';
}

class VerificationCompleted extends SignupState {
  @override
  String toString() => 'VerificationCompletedState';
}

class VerifyMobileNoInProgress extends SignupState {
  @override
  String toString() => 'VerifyMobileNoInProgressState';
}

class VerifyMobileNoFailed extends SignupState {
  @override
  String toString() => 'VerifyMobileNoInFailedState';
}

class VerifyMobileNoCompleted extends SignupState {
  final User user;

  VerifyMobileNoCompleted(this.user);

  @override
  String toString() => 'VerifyMobileNoCompletedState';
}

class SavingUserDetails extends SignupState {
  @override
  String toString() => 'SavingUserDetailsState';
}

class FailedSavingUserDetails extends SignupState {
  @override
  String toString() => 'FailedSavingUserDetailsState';
}

class CompletedSavingUserDetails extends SignupState {
  final GroceryUser user;
  CompletedSavingUserDetails(this.user);

  @override
  String toString() => 'CompletedSavingUserDetailsState';
}
