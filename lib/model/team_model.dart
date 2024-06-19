class TeamModel {
  String? status;
  List<Messages>? messages;

  TeamModel({this.status, this.messages});

  TeamModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(new Messages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.messages != null) {
      data['messages'] = this.messages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Messages {
  int? mamberId;
  int? userId;
  String? userName;
  String? phoneNumber;
  String? position;
  String? flatNumber;
  String? blockName;
  String? image;

  Messages(
      {this.mamberId,
      this.userId,
      this.userName,
      this.phoneNumber,
      this.position,
      this.flatNumber,
      this.blockName,
            this.image,

      });

  Messages.fromJson(Map<String, dynamic> json) {
    mamberId = json['mamberId'];
    userId = json['userId'];
    userName = json['userName']?? '';
    phoneNumber = json['phoneNumber']?? '';
    position = json['position']?? '';
    flatNumber = json['flatNumber']?? '';
    blockName = json['blockName']?? '';
        image = json['image']?? '';

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mamberId'] = this.mamberId;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['phoneNumber'] = this.phoneNumber;
    data['position'] = this.position;
    data['flatNumber'] = this.flatNumber;
    data['blockName'] = this.blockName;
        data['image'] = this.image;

    return data;
  }
}
