import 'package:cloud_firestore/cloud_firestore.dart';

class Messages {
  List<Message> queAndAns;

  Messages({this.queAndAns});

  factory Messages.fromFirestore(DocumentSnapshot snap) {
    return Messages(
      queAndAns: List.from(snap.data()['queAndAns']).map(
        (e) => Message.fromHashMap(e),
      ),
    );
  }
}

class Message {
  String ans;
  String que;
  Timestamp timestamp;
  String userId;
  String userName;
  String queId;

  Message({
    this.ans,
    this.que,
    this.timestamp,
    this.userId,
    this.userName,
    this.queId,
  });

  factory Message.fromHashMap(Map<String, dynamic> queAndAns) {
    return Message(
      ans: queAndAns['ans'],
      que: queAndAns['que'],
      timestamp: queAndAns['timestamp'],
      userId: queAndAns['userId'],
      userName: queAndAns['userName'],
      queId: queAndAns['queId'],
    );
  }
}
