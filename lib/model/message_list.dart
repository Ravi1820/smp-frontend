// class MessageListModel {
//   String? status;
//   List<Messages>? messages;

//   MessageListModel({this.status, this.messages});

//   MessageListModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     if (json['messages'] != null) {
//       messages = <Messages>[];
//       json['messages'].forEach((v) {
//         messages!.add(new Messages.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     if (this.messages != null) {
//       data['messages'] = this.messages!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Messages {
//   int? senderId;
//   String? senderDeviceToken;
//   String? senderName;
//   String? senderPicture;
//   int? receiverId;
//   String? receiverDeviceToken;
//   String? receiverName;
//   String? receiverPicture;

//   Messages(
//       {this.senderId,
//       this.senderDeviceToken,
//       this.senderName,
//       this.senderPicture,
//       this.receiverId,
//       this.receiverDeviceToken,
//       this.receiverName,
//       this.receiverPicture});

//   Messages.fromJson(Map<String, dynamic> json) {
//     senderId = json['senderId'];
//     senderDeviceToken = json['senderDeviceToken'];
//     senderName = json['senderName'];
//     senderPicture = json['senderPicture'];
//     receiverId = json['receiverId'];
//     receiverDeviceToken = json['receiverDeviceToken'];
//     receiverName = json['receiverName'];
//     receiverPicture = json['receiverPicture'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['senderId'] = this.senderId;
//     data['senderDeviceToken'] = this.senderDeviceToken;
//     data['senderName'] = this.senderName;
//     data['senderPicture'] = this.senderPicture;
//     data['receiverId'] = this.receiverId;
//     data['receiverDeviceToken'] = this.receiverDeviceToken;
//     data['receiverName'] = this.receiverName;
//     data['receiverPicture'] = this.receiverPicture;
//     return data;
//   }
// }


class MessageListModel {
  String? messages;
  List<Values>? values;
  String? status;

  MessageListModel({this.messages, this.values, this.status});

  MessageListModel.fromJson(Map<String, dynamic> json) {
    messages = json['messages'];
    if (json['values'] != null) {
      values = <Values>[];
      json['values'].forEach((v) {
        values!.add(new Values.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['messages'] = this.messages;
    if (this.values != null) {
      data['values'] = this.values!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Values {
  int? senderId;
  String? senderDeviceToken;
  String? senderName;
  String? senderPicture;
  int? receiverId;
  String? receiverDeviceToken;
  String? receiverName;
  String? receiverPicture;

  Values(
      {this.senderId,
      this.senderDeviceToken,
      this.senderName,
      this.senderPicture,
      this.receiverId,
      this.receiverDeviceToken,
      this.receiverName,
      this.receiverPicture});

  Values.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    senderDeviceToken = json['senderDeviceToken'];
    senderName = json['senderName'];
    senderPicture = json['senderPicture'];
    receiverId = json['receiverId'];
    receiverDeviceToken = json['receiverDeviceToken'];
    receiverName = json['receiverName'];
    receiverPicture = json['receiverPicture'];
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