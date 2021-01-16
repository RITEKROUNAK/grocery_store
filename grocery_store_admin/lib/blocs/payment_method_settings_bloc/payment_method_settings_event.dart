part of 'payment_method_settings_bloc.dart';

@immutable
abstract class PaymentMethodSettingsEvent {}

class GetPaymentMethods extends PaymentMethodSettingsEvent {}

class UpdatePaymentMethods extends PaymentMethodSettingsEvent {
  final Map map;

  UpdatePaymentMethods(this.map);
}
