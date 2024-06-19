class Notice {
  String? status;
  List<Values>? values;
  String? messages;

  Notice({this.status, this.values, this.messages});

  Notice.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['values'] != null) {
      values = <Values>[];
      json['values'].forEach((v) {
        values!.add(new Values.fromJson(v));
      });
    }
    messages = json['messages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.values != null) {
      data['values'] = this.values!.map((v) => v.toJson()).toList();
    }
    data['messages'] = this.messages;
    return data;
  }
}

class Values {
  int? id;
  String? noticeHeader;
  String? message;
  String? timeAgo;
  String? name;
  String? createdDate;

  Values({
    this.id,
    this.noticeHeader,
    this.message,
    this.timeAgo,
    this.name,
    this.createdDate
  });

  Values.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    noticeHeader = json['noticeHeader'];
    message = json['message'];
    timeAgo = json['timeAgo'];
    name = json['name'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['noticeHeader'] = this.noticeHeader;
    data['message'] = this.message;
    data['timeAgo'] = this.timeAgo;
    data['name'] = this.name;
    data['createdDate'] = this.createdDate;

    return data;
  }
}
