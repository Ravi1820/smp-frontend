// class SuccessModel {
//   final String msg;
//   final String passcode;

//   SuccessModel({
//     required this.msg,
//     required this.passcode,
//   });

//   factory SuccessModel.fromJson(Map<String, dynamic> json) {
//     final msg = json.containsKey("msg") ? json["msg"] as String : "Unknown";
//     final passcode =
//         json.containsKey("passcode") ? json["passcode"].toString() : "";
//     return SuccessModel(
//       msg: msg,
//       passcode: passcode,
//     );
//   }
// }



class SuccessModel {
  String? message;
  String? passcode;
  String? status;
  FlatDetails? flatDetails;

  SuccessModel({this.message, this.passcode, this.status, this.flatDetails});

  SuccessModel.fromJson(Map<String, dynamic> json) {
    message = json['message']?? '';
    passcode = json['passcode']?? '';
    status = json['status']?? '';
    flatDetails = json['flatDetails'] != null
        ? new FlatDetails.fromJson(json['flatDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['passcode'] = this.passcode;
    data['status'] = this.status;
    if (this.flatDetails != null) {
      data['flatDetails'] = this.flatDetails!.toJson();
    }
    return data;
  }
}

class FlatDetails {
  String? flatNumber;
  String? floorNumber;
  String? blockNumbber;
  String? address1;
  String? address2;
  String? aprtmentPincode;
  String? apartmentState;
  String? apartmentCountry;

  FlatDetails(
      {this.flatNumber,
      this.floorNumber,
      this.blockNumbber,
      this.address1,
      this.address2,
      this.aprtmentPincode,
      this.apartmentState,
      this.apartmentCountry});

  FlatDetails.fromJson(Map<String, dynamic> json) {
    flatNumber = json['flatNumber']?? '';
    floorNumber = json['floorNumber']?? '';
    blockNumbber = json['blockNumbber']?? '';
    address1 = json['address1']?? '';
    address2 = json['address2']?? '';
    aprtmentPincode = json['aprtmentPincode']?? '';
    apartmentState = json['apartmentState']?? '';
    apartmentCountry = json['apartmentCountry']?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flatNumber'] = this.flatNumber;
    data['floorNumber'] = this.floorNumber;
    data['blockNumbber'] = this.blockNumbber;
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    data['aprtmentPincode'] = this.aprtmentPincode;
    data['apartmentState'] = this.apartmentState;
    data['apartmentCountry'] = this.apartmentCountry;
    return data;
  }
}