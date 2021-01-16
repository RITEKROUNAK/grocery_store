part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class GetCurrentUserEvent extends UserEvent {
  @override
  String toString() => 'GetCurrentUserEvent';
}
