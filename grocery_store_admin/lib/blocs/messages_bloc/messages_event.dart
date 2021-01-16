part of 'messages_bloc.dart';

@immutable
abstract class MessagesEvent {}

class GetAllMessagesEvent extends MessagesEvent {
  @override
  String toString() => 'GetAllMessagesEvent';
}

class GetNewMessagesEvent extends MessagesEvent {
  @override
  String toString() => 'GetNewMessagesEvent';
}

class GetMessagesAnalyticsEvent extends MessagesEvent {
  @override
  String toString() => 'GetMessagesAnalyticsEvent';
}

class UpdateMessagesAnalyticsEvent extends MessagesEvent {
  final MessageAnalytics messageAnalytics;

  UpdateMessagesAnalyticsEvent(this.messageAnalytics);

  @override
  String toString() => 'UpdateMessagesAnalyticsEvent';
}

class PostAnswerEvent extends MessagesEvent {
  final String id;
  final String ans;
  final String queId;

  PostAnswerEvent({
    @required this.id,
    @required this.ans,
    @required this.queId,
  });

@override
  String toString() => 'PostAnswerEvent';
}
