part of 'initial_setup_bloc.dart';

@immutable
abstract class InitialSetupState {}

class InitialSetupInitialState extends InitialSetupState {
  @override
  String toString() => 'InitialSetupInitialState';
}

class ProceedInitialSetupInProgressState extends InitialSetupState {
  @override
  String toString() => 'ProceedInitialSetupInProgressState';
}

class ProceedInitialSetupCompletedState extends InitialSetupState {
  @override
  String toString() => 'ProceedInitialSetupCompletedState';
}

class ProceedInitialSetupFailedState extends InitialSetupState {
  @override
  String toString() => 'ProceedInitialSetupFailedState';
}

class CheckIfInitialSetupDoneInProgressState extends InitialSetupState {
  @override
  String toString() => 'CheckIfInitialSetupDoneInProgressState';
}

class CheckIfInitialSetupDoneCompletedState extends InitialSetupState {
  final bool isDone;

  CheckIfInitialSetupDoneCompletedState(this.isDone);
  @override
  String toString() => 'CheckIfInitialSetupDoneCompletedState';
}

class CheckIfInitialSetupDoneFailedState extends InitialSetupState {
  @override
  String toString() => 'CheckIfInitialSetupDoneFailedState';
}
