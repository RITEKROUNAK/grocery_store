part of 'share_product_bloc.dart';

@immutable
abstract class ShareProductEvent {}

class ShareProductInitEvent extends ShareProductEvent {
  final String id;

  ShareProductInitEvent(this.id);

  @override
  String toString() => 'ShareProductInitEvent';
}
