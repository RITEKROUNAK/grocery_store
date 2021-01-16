import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/repositories/authentication_repository.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthenticationRepository authenticationRepository;
  final UserDataRepository userDataRepository;

  SignInBloc({this.authenticationRepository, this.userDataRepository})
      : super(null);

  @override
  Stream<SignInState> mapEventToState(
    SignInEvent event,
  ) async* {
    if (event is CheckIfSignedInEvent) {
      yield* mapCheckIfSignedInEventToState();
    }
    if (event is GetCurrentUserEvent) {
      yield* mapGetCurrentUserEventToState();
    }
    if (event is SignoutEvent) {
      yield* mapSignoutEventToState();
    }
    if (event is SignInWithEmailEvent) {
      yield* mapSignInWithEmailEventToState(
        email: event.email,
        password: event.password,
      );
    }
    if (event is CheckIfNewAdminEvent) {
      yield* mapCheckIfNewAdminEventToState(event.uid);
    }
  }

  Stream<SignInState> mapCheckIfSignedInEventToState() async* {
    try {
      bool isSignedIn = await authenticationRepository.checkIfSignedIn();
      if (isSignedIn != null) {
        if (isSignedIn) {
          yield CheckIfSignedInEventCompletedState(true);
        } else {
          yield CheckIfSignedInEventCompletedState(false);
        }
      } else {
        yield CheckIfSignedInEventFailedState();
      }
    } catch (e) {
      print(e);
      yield CheckIfSignedInEventFailedState();
    }
  }

  Stream<SignInState> mapGetCurrentUserEventToState() async* {
    try {
      User currentUser =
          await authenticationRepository.getCurrentUser();
      if (currentUser != null) {
        yield GetCurrentUserCompletedState(currentUser);
      } else {
        yield GetCurrentUserFailedState();
      }
    } catch (e) {
      print(e);
      yield GetCurrentUserFailedState();
    }
  }

  Stream<SignInState> mapSignoutEventToState() async* {
    yield SignoutInProgressState();
    try {
      bool isSignedOut = await authenticationRepository.signOutUser();
      if (isSignedOut) {
        yield SignoutCompletedState();
      } else {
        yield SignoutFailedState();
      }
    } catch (e) {
      print(e);
      yield SignoutFailedState();
    }
  }

  Stream<SignInState> mapSignInWithEmailEventToState({
    String email,
    String password,
  }) async* {
    yield SignInWithEmailEventInProgressState();
    try {
      User firebaseUser =
          await authenticationRepository.signInWithEmail(email, password);
      if (firebaseUser != null) {
        yield SignInWithEmailEventCompletedState(firebaseUser);
      } else {
        yield SignInWithEmailEventFailedState();
      }
    } catch (e) {
      print(e);
      yield SignInWithEmailEventFailedState();
    }
  }

  Stream<SignInState> mapCheckIfNewAdminEventToState(String uid) async* {
    yield CheckIfNewAdminInProgressState();
    try {
      bool isSuccessful = await userDataRepository.checkIfNewAdmin(uid);
      if (isSuccessful) {
        yield CheckIfNewAdminCompletedState();
      } else {
        yield CheckIfNewAdminFailedState();
      }
    } catch (e) {
      print(e);
      yield CheckIfNewAdminFailedState();
    }
  }
}
