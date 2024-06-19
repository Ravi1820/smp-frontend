class PaymentModel {
  int? id;
  double? amount;
  String? endDate;
  String? startDate;
  double? fineAmount;
  int? userId;
  String? month;
  String? year;
  int? feesTypeId;
  String? paidStatus;
  String? feesDescription;
  int? apartmentId;
  Apartment? apartment;
  FeeTypeDetails? feeTypeDetails;

  PaymentModel(
      {this.id,
      this.amount,
      this.endDate,
      this.startDate,
      this.fineAmount,
      this.userId,
      this.month,
      this.year,
      this.feesTypeId,
      this.paidStatus,
      this.feesDescription,
      this.apartmentId,
      this.apartment,
      this.feeTypeDetails});

  PaymentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    amount = json['amount'] ?? 0.0;
    endDate = json['endDate'] ?? "";
    startDate = json['startDate'] ?? "";
    fineAmount = json['fineAmount'] ?? 0.0;
    userId = json['userId'] ?? 0;
    month = json['month'] ?? "";
    year = json['year'] ?? "";
    feesTypeId = json['feesTypeId'] ?? 0;
    paidStatus = json['paidStatus'] ?? '';
    feesDescription = json['feesDescription'] ?? '';
    apartmentId = json['apartmentId'] ?? 0;
    apartment = json['apartment'] != null
        ? Apartment.fromJson(json['apartment'])
        : null;
    feeTypeDetails = json['feeTypeDetails'] != null
        ? FeeTypeDetails.fromJson(json['feeTypeDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['amount'] = amount;
    data['endDate'] = endDate;
    data['startDate'] = startDate;
    data['fineAmount'] = fineAmount;
    data['userId'] = userId;
    data['month'] = month;
    data['year'] = year;
    data['feesTypeId'] = feesTypeId;
    data['paidStatus'] = paidStatus;
    data['feesDescription'] = feesDescription;
    data['apartmentId'] = apartmentId;
    if (apartment != null) {
      data['apartment'] = apartment!.toJson();
    }
    if (feeTypeDetails != null) {
      data['feeTypeDetails'] = feeTypeDetails!.toJson();
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
  String? paymentQrCodeImage;
  String? upiId;

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
      this.status,
      this.paymentQrCodeImage,
      this.upiId});

  Apartment.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
    emailId = json['emailId'] ?? '';
    mobile = json['mobile'] ?? '';
    landline = json['landline'] ?? '';
    address1 = json['address1'] ?? '';
    address2 = json['address2'] ?? '';
    profilePicture = json['profilePicture'] ?? '';
    state = json['state'] ?? '';
    pinCode = json['pinCode'] ?? 0;
    country = json['country'] ?? '';
    status = json['status'] ?? '';
    paymentQrCodeImage = json['paymentQrCodeImage'] ?? '';
    upiId = json['upiId'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['emailId'] = emailId;
    data['mobile'] = mobile;
    data['landline'] = landline;
    data['address1'] = address1;
    data['address2'] = address2;
    data['profilePicture'] = profilePicture;
    data['state'] = state;
    data['pinCode'] = pinCode;
    data['country'] = country;
    data['status'] = status;
    data['paymentQrCodeImage'] = paymentQrCodeImage;
    data['upiId'] = upiId;
    return data;
  }
}

class FeeTypeDetails {
  int? id;
  String? feesType;

  FeeTypeDetails({this.id, this.feesType});

  FeeTypeDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    feesType = json['feesType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['feesType'] = feesType;
    return data;
  }
}
