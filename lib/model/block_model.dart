class BlockModel {
  int? id;
  int? blockNumber;
  String? blockName;
  int? apartmentId;
  String? status;
  Apartment? apartment;

  BlockModel(
      {this.id,
      this.blockNumber,
      this.blockName,
      this.apartmentId,
      this.status,
      this.apartment});

  BlockModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    blockNumber = json['blockNumber'];
    blockName = json['blockName'] ?? "";
    apartmentId = json['apartmentId'] ?? "";
    status = json['status'] ?? "";
    apartment = json['apartment'] != null
        ? new Apartment.fromJson(json['apartment'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['blockNumber'] = this.blockNumber;
    data['blockName'] = this.blockName;
    data['apartmentId'] = this.apartmentId;
    data['status'] = this.status;
    if (this.apartment != null) {
      data['apartment'] = this.apartment!.toJson();
    }
    return data;
  }
}

class Apartment {
  int? id;
  String? name;
  String? emailId;
  String? mobile;
  String? landline;
  String? address1;
  String? address2;
  String? profilePicture;
  String? state;
  int? pinCode;
  String? country;
  String? status;

  Apartment(
      {this.id,
      this.name,
      this.emailId,
      this.mobile,
      this.landline,
      this.address1,
      this.address2,
      this.profilePicture,
      this.state,
      this.pinCode,
      this.country,
      this.status});

  Apartment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? '';
    emailId = json['emailId'] ?? '';
    mobile = json['mobile'] ?? '';
    landline = json['landline'] ?? '';
    address1 = json['address1'] ?? '';
    address2 = json['address2'] ?? '';
    profilePicture = json['profilePicture'] ?? '';
    state = json['state'] ?? '';
    pinCode = json['pinCode'] ?? '';
    country = json['country'] ?? '';
    status = json['status'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['emailId'] = this.emailId;
    data['mobile'] = this.mobile;
    data['landline'] = this.landline;
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    data['profilePicture'] = this.profilePicture;
    data['state'] = this.state;
    data['pinCode'] = this.pinCode;
    data['country'] = this.country;
    data['status'] = this.status;
    return data;
  }
}
