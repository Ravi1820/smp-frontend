class MessageModel {
  int id;
  String message;
  int senderId;
  int receiverId;
  DateTime createdTime;

  MessageModel({
    required this.id,
    required this.message,
    required this.senderId,
    required this.receiverId,
    required this.createdTime,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      message: json['message'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      createdTime: DateTime.parse(json['createdTime']),
      // sender: User.fromJson(json['sender']),
      // receiver: User.fromJson(json['receiver']),
    );
  }
}

// class User {
//   int id;
//   String emailId;
//   String userName;
//   String mobile;
//   // Other user fields...

//   User({
//     required this.id,
//     required this.emailId,
//     required this.userName,
//     required this.mobile,
//     // Other user fields...
//   });

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'],
//       emailId: json['emailId'],
//       userName: json['userName'],
//       mobile: json['mobile'],
//       // Map other user fields here...
//     );
//   }
// }

class Apartment {
  int id;
  String name;
  String emailId;
  String mobile;
  // Other apartment fields...

  Apartment({
    required this.id,
    required this.name,
    required this.emailId,
    required this.mobile,
    // Other apartment fields...
  });

  factory Apartment.fromJson(Map<String, dynamic> json) {
    return Apartment(
      id: json['id'],
      name: json['name'],
      emailId: json['emailId'],
      mobile: json['mobile'],
      // Map other apartment fields here...
    );
  }
}
