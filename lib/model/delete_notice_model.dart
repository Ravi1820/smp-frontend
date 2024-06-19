class DeleteNoticeModel{
  String? status;
  String? message;
  bool? isAdd;

  DeleteNoticeModel({this.status, this.message, this.isAdd});

  DeleteNoticeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    isAdd = json['is_add'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['is_add'] = this.isAdd;
    return data;
  }
}