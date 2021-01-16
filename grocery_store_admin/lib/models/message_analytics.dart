import 'package:cloud_firestore/cloud_firestore.dart';

class MessageAnalytics {
  var allMessages;
  var newMessages;

  MessageAnalytics({
    this.allMessages,
    this.newMessages,
  });

  factory MessageAnalytics.fromFirestore(DocumentSnapshot snapshot) {
    return MessageAnalytics(
      allMessages: snapshot.data()['allMessages'],
      newMessages: snapshot.data()['newMessages'],
    );
  }
}
