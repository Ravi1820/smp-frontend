

class EditPreApproved {
  String? message;
  Value? value;
  String? status;

  EditPreApproved({this.message, this.value, this.status});

  EditPreApproved.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    value = json['value'] != null ? new Value.fromJson(json['value']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.value != null) {
      data['value'] = this.value!.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class Value {
  int? id;
  String? name;
  String? validFrom;
  String? validTo;
  int? numberOfGuest;
  String? purpose;
  String? mobileNumber;

  Value(
      {this.id,
        this.name,
        this.validFrom,
        this.validTo,
        this.numberOfGuest,
        this.purpose,
        this.mobileNumber});

  Value.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    name = json['name']??"";
    validFrom = json['validFrom']??"";
    validTo = json['validTo']?? "";
    numberOfGuest = json['numberOfGuest']?? "";
    purpose = json['purpose']?? "";
    mobileNumber = json['mobileNumber']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['validFrom'] = this.validFrom;
    data['validTo'] = this.validTo;
    data['numberOfGuest'] = this.numberOfGuest;
    data['purpose'] = this.purpose;
    data['mobileNumber'] = this.mobileNumber;
    return data;
  }
}