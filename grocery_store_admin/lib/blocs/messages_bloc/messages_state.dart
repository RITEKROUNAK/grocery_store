part of 'messages_bloc.dart';

@immutable
abstract class MessagesState {}

class MessagesInitial extends MessagesState {}

class AllMessagesInitial extends MessagesState {}

class NewMessagesInitial extends MessagesState {}

class GetMessageAnalyticsCompletedState extends MessagesState {
  final MessageAnalytics messageAnalytics;

  GetMessageAnalyticsCompletedState({
    @required this.messageAnalytics,
  });

  String toString() => 'GetMessageAnalyticsCompletedState';
}

class GetMessageAnalyticsFailedState extends MessagesState {
  String toString() => 'GetMessageAnalyticsFailedState';
}

class GetMessageAnalyticsInProgressState extends MessagesState {
  String toString() => 'GetMessageAnalyticsInProgressState';
}

class UpdateMessageAnalyticsState extends MessagesState {
  final MessageAnalytics orderAnalytics;

  UpdateMessageAnalyticsState(this.orderAnalytics);

  String toString() => 'UpdateMessageAnalyticsState';
}

class GetNewMessagesCompletedState extends MessagesState {
  final List<Product> products;
  GetNewMessagesCompletedState(this.products);

  String toString() => 'GetNewMessagesCompletedState';
}

class GetNewMessagesFailedState extends MessagesState {
  String toString() => 'GetNewMessagesFailedState';
}

class GetNewMessagesInProgressState extends MessagesState {
  String toString() => 'GetNewMessagesInProgressState';
}

class GetAllMessagesCompletedState extends MessagesState {
  final List<Product> products;
  GetAllMessagesCompletedState(this.products);

  String toString() => 'GetAllMessagesCompletedState';
}

class GetAllMessagesFailedState extends MessagesState {
  String toString() => 'GetAllMessagesFailedState';
}

class GetAllMessagesInProgressState extends MessagesState {
  String toString() => 'GetAllMessagesInProgressState';
}

class PostAnswerCompletedState extends MessagesState {
  String toString() => 'PostAnswerCompletedState';
}

class PostAnswerFailedState extends MessagesState {
  String toString() => 'PostAnswerFailedState';
}

class PostAnswerInProgressState extends MessagesState {
  String toString() => 'PostAnswerInProgressState';
}
