part of 'user_bloc.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class GetCurrentUserInProgressState extends UserState {
  @override
  String toString() => 'GetCurrentUserInProgressState';
}

class GetCurrentUserFailedState extends UserState {
  @override
  String toString() => 'GetCurrentUserFailedState';
}

class GetCurrentUserCompletedState extends UserState {
 final User firebaseUser;

  GetCurrentUserCompletedState(this.firebaseUser);
  @override
  String toString() => 'GetCurrentUserCompletedState';
}
