part of 'initial_setup_bloc.dart';

@immutable
abstract class InitialSetupEvent {}

class ProceedInitialSetupEvent extends InitialSetupEvent {
  final Map initialSetupMap;

  ProceedInitialSetupEvent(this.initialSetupMap);
  @override
  String toString() => 'ProceedInitialSetupEvent';
}

class CheckIfInitialSetupDoneEvent extends InitialSetupEvent {
  @override
  String toString() => 'CheckIfInitialSetupDoneEvent';
}
