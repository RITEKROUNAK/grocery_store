import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

part 'initial_setup_event.dart';
part 'initial_setup_state.dart';

class InitialSetupBloc extends Bloc<InitialSetupEvent, InitialSetupState> {
  final UserDataRepository userDataRepository;

  InitialSetupBloc({this.userDataRepository}) : super(null);

  @override
  Stream<InitialSetupState> mapEventToState(
    InitialSetupEvent event,
  ) async* {
    if (event is ProceedInitialSetupEvent) {
      yield* mapProceedInitialSetupEventToState(event.initialSetupMap);
    }
    if (event is CheckIfInitialSetupDoneEvent) {
      yield* mapCheckIfInitialSetupDoneEventToState();
    }
  }

  Stream<InitialSetupState> mapProceedInitialSetupEventToState(
      Map initialSetupMap) async* {
    yield ProceedInitialSetupInProgressState();
    try {
      bool isDone =
          await userDataRepository.proceedInitialSetup(initialSetupMap);
      if (isDone != null) {
        if (isDone) {
          yield ProceedInitialSetupCompletedState();
        } else {
          yield ProceedInitialSetupFailedState();
        }
      } else {
        yield ProceedInitialSetupFailedState();
      }
    } catch (e) {
      print(e);
      yield ProceedInitialSetupFailedState();
    }
  }

  Stream<InitialSetupState> mapCheckIfInitialSetupDoneEventToState() async* {
    yield CheckIfInitialSetupDoneInProgressState();
    try {
      bool isDone = await userDataRepository.checkIfInitialSetupDone();

      if (isDone != null) {
        yield CheckIfInitialSetupDoneCompletedState(isDone);
      } else {
        yield CheckIfInitialSetupDoneFailedState();
      }
    } catch (e) {
      print(e);
      yield CheckIfInitialSetupDoneFailedState();
    }
  }
}
