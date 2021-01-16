class Card {
  String cardNumber;
  String cardHolderName;
  String cvvCode;
  String expiryDate;

  Card({
    this.cardHolderName,
    this.cardNumber,
    this.cvvCode,
    this.expiryDate,
  });

  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
      cardHolderName: json['cardHolderName'],
      cardNumber: json['cardNumber'],
      cvvCode: json['cvvCode'],
      expiryDate: json['expiryDate'],
    );
  }
}

// import 'dart:convert';

// Card cardFromJson(String str) {
//   final jsonData = json.decode(str);
//   return Card.fromMap(jsonData);
// }

// String cardToJson(Card data) {
//   final dyn = data.toMap();
//   return json.encode(dyn);
// }

// class Card {
//   int id;
//   String cardNumber;
//   String cardHolderName;
//   String cvvCode;
//   String expiryDate;

//   Card({
//     this.id,
//     this.expiryDate,
//     this.cardHolderName,
//     this.cardNumber,
//     this.cvvCode,
//   });

//   factory Card.fromMap(Map<String, dynamic> json) => new Card(
//         id: json["id"],
//         expiryDate: json["expiryDate"],
//         cardHolderName: json["cardHolderName"],
//         cvvCode: json["cvvCode"],
//         cardNumber: json["cardNumber"],
//       );

//   Map<String, dynamic> toMap() => {
//         "id": id,
//         "expiryDate": expiryDate,
//         "cardHolderName": cardHolderName,
//         "cvvCode": cvvCode,
//         "cardNumber": cardNumber,
//       };
// }
