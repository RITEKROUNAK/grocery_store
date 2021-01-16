part of 'payment_method_settings_bloc.dart';

@immutable
abstract class PaymentMethodSettingsState {}

class PaymentMethodSettingsInitial extends PaymentMethodSettingsState {}

class GetPaymentMethodsCompletedState extends PaymentMethodSettingsState {
  final PaymentMethods paymentMethods;
  GetPaymentMethodsCompletedState(this.paymentMethods);

  String toString() => 'GetPaymentMethodsCompletedState';
}

class GetPaymentMethodsFailedState extends PaymentMethodSettingsState {
  String toString() => 'GetPaymentMethodsFailedState';
}

class GetPaymentMethodsInProgressState extends PaymentMethodSettingsState {
  String toString() => 'GetPaymentMethodsInProgressState';
}

class UpdatePaymentMethodsCompletedState extends PaymentMethodSettingsState {
  String toString() => 'UpdatePaymentMethodsCompletedState';
}

class UpdatePaymentMethodsFailedState extends PaymentMethodSettingsState {
  String toString() => 'UpdatePaymentMethodsFailedState';
}

class UpdatePaymentMethodsInProgressState extends PaymentMethodSettingsState {
  String toString() => 'UpdatePaymentMethodsInProgressState';
}
