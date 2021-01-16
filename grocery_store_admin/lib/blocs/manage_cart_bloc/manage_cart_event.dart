part of 'manage_cart_bloc.dart';

@immutable
abstract class ManageCartEvent {}

class GetCartInfo extends ManageCartEvent {}

class UpdateCartInfo extends ManageCartEvent {
  final Map map;

  UpdateCartInfo(this.map);
}
