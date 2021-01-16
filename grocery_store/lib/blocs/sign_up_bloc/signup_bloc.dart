import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:grocery_store/models/user.dart';
import 'package:grocery_store/repositories/authentication_repository.dart';
import 'package:grocery_store/repositories/user_data_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthenticationRepository authenticationRepository;
  final UserDataRepository userDataRepository;

  SignupBloc({
    this.authenticationRepository,
    this.userDataRepository,
  }) : super(null);

  SignupState get initialState => SignupInitial();

  @override
  Stream<SignupState> mapEventToState(SignupEvent event) async* {
    print(event);

    if (event is SignupWithMobileNo) {
      yield* mapSignupWithMobileNoEventToState(
        mobileNo: event.mobileNo,
      );
    } else if (event is SignupWithGoogle) {
      yield* mapSignupWithGoogleEventToState();
    } else if (event is VerifyMobileNo) {
      yield* mapVerifyMobileNoToState(event.otp);
    } else if (event is ResendCode) {
      yield* mapSignupWithMobileNoEventToState(
        mobileNo: event.mobileNo,
      );
    } else if (event is SaveUserDetails) {
      yield* mapSaveUserDetailsToState(
        email: event.email,
        mobileNo: event.mobileNo,
        name: event.name,
        firebaseUser: event.firebaseUser,
        loggedInVia: event.loggedInVia,
      );
    }
  }

  Stream<SignupState> mapSignupWithMobileNoEventToState({
    String mobileNo,
  }) async* {
    yield VerificationInProgress();

    try {
      bool isSent = await authenticationRepository.signInWithMobileNo(mobileNo);
      if (isSent) {
        yield VerificationCompleted();
      } else {
        yield VerificationFailed();
      }
    } catch (e) {
      print('ERROR');
      print(e);
    }
  }

  Stream<SignupState> mapVerifyMobileNoToState(String otp) async* {
    yield VerifyMobileNoInProgress();

    try {
      User firebaseUser = await authenticationRepository.signInWithSmsCode(otp);
      print(firebaseUser.phoneNumber);
      if (firebaseUser != null) {
        yield VerifyMobileNoCompleted(firebaseUser);
      } else {
        yield VerifyMobileNoFailed();
      }
    } catch (e) {
      yield VerifyMobileNoFailed();
      print(e);
    }
  }

  Stream<SignupState> mapResendCodeToState(String mobileNo) async* {
    yield VerificationInProgress();

    try {
      bool isSent = await authenticationRepository.signInWithMobileNo(mobileNo);
      if (isSent) {
        yield VerificationCompleted();
      } else {
        yield VerificationFailed();
      }
    } catch (e) {
      print('ERROR');
      print(e);
    }
  }

  Stream<SignupState> mapSignupWithGoogleEventToState() async* {
    yield SignUpInProgress();

    try {
      User firebaseUser = await authenticationRepository.signUpWithGoogle();
      if (firebaseUser != null) {
        yield SignupWithGoogleInitialCompleted(firebaseUser);
      } else {
        yield SignupWithGoogleInitialFailed();
      }
    } catch (e) {
      print(e);
      yield SignupWithGoogleInitialFailed();
    }
  }

  Stream<SignupState> mapSaveUserDetailsToState({
    String mobileNo,
    String name,
    String email,
    User firebaseUser,
    String loggedInVia,
  }) async* {
    yield SavingUserDetails();
    try {
      GroceryUser user = await userDataRepository.saveUserDetails(
        firebaseUser.uid,
        name,
        email,
        mobileNo,
        firebaseUser.photoURL,
        '',
        [],
        [],
        loggedInVia,
      );

      if (user != null) {
        yield CompletedSavingUserDetails(user);
      } else {
        yield FailedSavingUserDetails();
      }
    } catch (e) {
      print(e);
      yield FailedSavingUserDetails();
    }
  }
}
