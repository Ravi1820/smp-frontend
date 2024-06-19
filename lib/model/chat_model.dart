// class ChatModel {
//   int senderId;
//   String senderDeviceToken;
//   String senderPicture;
//   String senderName;
//   int receiverId;
//   String receiverDeviceToken;
//   String receiverPicture;

//   ChatModel({
//     required this.senderId,
//     required this.senderDeviceToken,
//     required this.senderName,
//     required this.senderPicture,
//     required this.receiverId,
//     required this.receiverDeviceToken,
//     required this.receiverPicture,
//   });

//   factory ChatModel.fromJson(Map<String, dynamic> json) {
//     return ChatModel(
//       senderId: json['senderId'] as int,
//       senderDeviceToken: json['senderDeviceToken'] as String,
//       senderName: json['senderName'] as String,
//       senderPicture: json['senderPicture'] as String,
//       receiverId: json['receiverId'] as int,
//       receiverDeviceToken: json['receiverDeviceToken'] as String,
//       receiverPicture: json['receiverPicture'] as String,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'senderId': senderId,
//       'senderName': senderName,
//       'senderDeviceToken': senderDeviceToken,
//       'senderPicture': senderPicture,
//       'receiverId': receiverId,
//       'receiverDeviceToken': receiverDeviceToken,
//       'receiverPicture': receiverPicture,
//     };
//   }
// }

// [
//     {
//         "senderId": 2,
//         "senderDeviceToken": "ccvJGequTy6x-XYeUIl8yN:APA91bFMYIEqF6itqDhwDFpJKQcLcHms2c_legKxGSP7phzUaLRoHLXOETpkIaHpP5ivc3ZJPlUbyBoZVwvqBmc5rhveoYKj6FKHum8oTwvYhcySy_JG5oiGJs6nB98JMjgnmGUfBqJ9",
//         "senderName": " ee  ",
//         "senderPicture": "2024_02_17_16_10_55_APItest2.png",
//         "receiverId": 1,
//         "receiverDeviceToken": null,
//         "receiverName": "Mr. Ram chandra",
//         "receiverPicture": null
//     }
// ]

class ChatModel {
  int? senderId;
  String? senderDeviceToken;
  String? senderName;
  String? senderPicture;
  int? receiverId;
  String? receiverDeviceToken;
  String? receiverName;
  String? receiverPicture;

  ChatModel(
      {this.senderId,
      this.senderDeviceToken,
      this.senderName,
      this.senderPicture,
      this.receiverId,
      this.receiverDeviceToken,
      this.receiverName,
      this.receiverPicture});

  ChatModel.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'] ?? 0;
    senderDeviceToken = json['senderDeviceToken'] ?? "";
    senderName = json['senderName'] ?? "";
    senderPicture = json['senderPicture'] ?? "";
    receiverId = json['receiverId'] ?? 0;
    receiverDeviceToken = json['receiverDeviceToken'] ?? "";
    receiverName = json['receiverName'] ?? "";
    receiverPicture = json['receiverPicture'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['senderId'] = this.senderId;
    data['senderDeviceToken'] = this.senderDeviceToken;
    data['senderName'] = this.senderName;
    data['senderPicture'] = this.senderPicture;
    data['receiverId'] = this.receiverId;
    data['receiverDeviceToken'] = this.receiverDeviceToken;
    data['receiverName'] = this.receiverName;
    data['receiverPicture'] = this.receiverPicture;
    return data;
  }
}
