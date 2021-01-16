import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_store_delivery/repositories/authentication_repository.dart';
import 'package:meta/meta.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final AuthenticationRepository authenticationRepository;
  UserBloc({this.authenticationRepository}) : super(UserInitial());

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is GetCurrentUserEvent) {
      yield* mapGetCurrentUserEventToState();
    }
  }

  Stream<UserState> mapGetCurrentUserEventToState() async* {
    yield GetCurrentUserInProgressState();
    try {
      User firebaseUser =
          await authenticationRepository.getCurrentUser();
      if (firebaseUser != null) {
        yield GetCurrentUserCompletedState(firebaseUser);
      } else {
        yield GetCurrentUserFailedState();
      }
    } catch (e) {
      print(e);
      yield GetCurrentUserFailedState();
    }
  }
}
