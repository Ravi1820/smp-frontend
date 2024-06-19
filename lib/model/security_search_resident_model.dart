
class SecuritySearchResidentModel {
  int? id;
  String? fullName;
  String? picture;
  String? mobileNumber;
  String? roleName;
  String? blockName;
  String? flatNummber;
  String? deviceId;
  String? floorNumber;

  SecuritySearchResidentModel(
      {this.id,
      this.fullName,
      this.picture,
      this.mobileNumber,
      this.blockName,
      this.flatNummber,
      this.deviceId,
        this.roleName,
      this.floorNumber});

  SecuritySearchResidentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'] ?? "";
    picture = json['picture'] ?? "";
    mobileNumber = json['mobileNumber'] ?? "";
    blockName = json['blockName'] ?? "";
    flatNummber = json['flatNummber'] ?? "";
    deviceId = json['deviceId'] ?? "";
    roleName = json['roleName'] ?? "";
    floorNumber = json['floorNumber'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullName'] = this.fullName;
    data['picture'] = this.picture;
    data['mobileNumber'] = this.mobileNumber;
    data['blockName'] = this.blockName;
    data['flatNummber'] = this.flatNummber;
    data['roleName'] = this.roleName;
    data['deviceId'] = this.deviceId;
    data['floorNumber'] = this.floorNumber;
    return data;
  }
}
