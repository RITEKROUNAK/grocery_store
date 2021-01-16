part of 'card_bloc.dart';

@immutable
abstract class CardEvent {}

class AddCardEvent extends CardEvent {
  final Map<String, dynamic> card;

  AddCardEvent(this.card);

  @override
  String toString() => 'AddCardEvent';
}

class EditCardEvent extends CardEvent {
  final Map<String, dynamic> card;
  final int index;

  EditCardEvent(this.card, this.index);

  @override
  String toString() => 'EditCardEvent';
}

class GetAllCardsEvent extends CardEvent {
  @override
  String toString() => 'GetAllCardsEvent';
}
