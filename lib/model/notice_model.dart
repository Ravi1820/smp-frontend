class NoticeCreateModel {
  String? status;
  List<String>? deviceList;
  bool? isAdd;
  String? message;

  NoticeCreateModel({this.status, this.deviceList, this.isAdd, this.message});

  NoticeCreateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? '';
    deviceList = json['deviceList'].cast<String>();
    isAdd = json['is_add'];
    message = json['message'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['deviceList'] = this.deviceList;
    data['is_add'] = this.isAdd;
    data['message'] = this.message;
    return data;
  }
}
