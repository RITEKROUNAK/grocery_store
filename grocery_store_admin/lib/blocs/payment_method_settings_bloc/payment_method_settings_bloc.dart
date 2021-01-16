import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/models/payment_methods.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

part 'payment_method_settings_event.dart';
part 'payment_method_settings_state.dart';

class PaymentMethodSettingsBloc
    extends Bloc<PaymentMethodSettingsEvent, PaymentMethodSettingsState> {
  final UserDataRepository userDataRepository;

  PaymentMethodSettingsBloc({this.userDataRepository})
      : super(PaymentMethodSettingsInitial());

  @override
  Stream<PaymentMethodSettingsState> mapEventToState(
    PaymentMethodSettingsEvent event,
  ) async* {
    if (event is GetPaymentMethods) {
      yield* mapGetPaymentMethodsToState();
    }
    if (event is UpdatePaymentMethods) {
      yield* mapUpdatePaymentMethodsToState(event.map);
    }
  }

  Stream<PaymentMethodSettingsState> mapGetPaymentMethodsToState() async* {
    yield GetPaymentMethodsInProgressState();
    try {
      PaymentMethods paymentMethods =
          await userDataRepository.getPaymentMethods();
      if (paymentMethods != null) {
        yield GetPaymentMethodsCompletedState(paymentMethods);
      } else {
        yield GetPaymentMethodsFailedState();
      }
    } catch (e) {
      print(e);
      yield GetPaymentMethodsFailedState();
    }
  }

  Stream<PaymentMethodSettingsState> mapUpdatePaymentMethodsToState(
      Map map) async* {
    yield UpdatePaymentMethodsInProgressState();
    try {
      bool isUpdated = await userDataRepository.updatePaymentMethods(map);
      if (isUpdated) {
        yield UpdatePaymentMethodsCompletedState();
      } else {
        yield UpdatePaymentMethodsFailedState();
      }
    } catch (e) {
      print(e);
      yield UpdatePaymentMethodsFailedState();
    }
  }
}
