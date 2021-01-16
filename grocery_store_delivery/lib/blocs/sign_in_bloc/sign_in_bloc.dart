import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_store_delivery/models/user.dart';
import 'package:grocery_store_delivery/repositories/authentication_repository.dart';
import 'package:grocery_store_delivery/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthenticationRepository authenticationRepository;
  final UserDataRepository userDataRepository;

  SignInBloc({this.authenticationRepository, this.userDataRepository})
      : super(SignInInitial());

  @override
  Stream<SignInState> mapEventToState(
    SignInEvent event,
  ) async* {
    if (event is CheckIfSignedInEvent) {
      yield* mapCheckIfSignedInEventToState();
    }
    if (event is SignInWithEmailEvent) {
      yield* mapSignInWithEmailEventToState(
        email: event.email,
        password: event.password,
      );
    }
    if (event is SignOutEvent) {
      yield* mapSignOutEventToState();
    }
    if (event is ChangePasswordEvent) {
      yield* mapChangePasswordEventToState(event.user);
    }
  }

  Stream<SignInState> mapCheckIfSignedInEventToState() async* {
    try {
      String res = await authenticationRepository.checkIfSignedIn();
      if (res != null) {
        yield CheckIfSignedInEventCompletedState(res);
      } else {
        yield CheckIfSignedInEventFailedState();
      }
    } catch (e) {
      print(e);
      yield CheckIfSignedInEventFailedState();
    }
  }

  Stream<SignInState> mapSignInWithEmailEventToState({
    String email,
    String password,
  }) async* {
    yield SignInWithEmailEventInProgressState();
    try {
      String res =
          await authenticationRepository.signInWithEmail(email, password);
      if (res != null) {
        yield SignInWithEmailEventCompletedState(res);
      } else {
        yield SignInWithEmailEventFailedState();
      }
    } catch (e) {
      print(e);
      yield SignInWithEmailEventFailedState();
    }
  }

  Stream<SignInState> mapSignOutEventToState() async* {
    yield SignOutEventInProgressState();
    try {
      bool isSignedOut = await authenticationRepository.signOut();
      if (isSignedOut != null) {
        yield SignOutEventCompletedState();
      } else {
        yield SignOutEventFailedState();
      }
    } catch (e) {
      print(e);
      yield SignOutEventFailedState();
    }
  }

  Stream<SignInState> mapChangePasswordEventToState(DeliveryUser user) async* {
    yield ChangePasswordEventInProgressState();
    try {
      bool isChanged = await authenticationRepository.changePassword(user);
      if (isChanged) {
        yield ChangePasswordEventCompletedState();
      } else {
        yield ChangePasswordEventFailedState();
      }
    } catch (e) {
      print(e);
      yield ChangePasswordEventFailedState();
    }
  }
}
