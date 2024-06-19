class VisitorsModel {
  final String visitorName;
  final int id;
  final int securityId;
  final int residentId;
  final String gender;
  final String proofDetails;
  final String status;
  final String guestMobile;
  final String purpose;
  final String visitorType;
  final String checkedIn;
  final String fromAddress;
  final String checkedOut;
  final String proofType;
  final String? image;

  List<dynamic> visitorImages; // Add this property

  VisitorsModel({
    required this.visitorName,
    required this.id,
    required this.proofDetails,
    required this.status,
    required this.guestMobile,
    required this.purpose,
    required this.visitorType,
    required this.checkedIn,
    required this.fromAddress,
    required this.checkedOut,
    required this.gender,
    required this.residentId,
    required this.proofType,
    required this.securityId,
    required this.visitorImages,
    required this.image,
  });

  factory VisitorsModel.fromJson(Map<String, dynamic> json) {
    return VisitorsModel(
      visitorName: json["visitorName"] ?? "",
      id: json["id"] ?? -1,
      securityId: json["securityId"] ?? -1,
      residentId: json["residentId"] ?? -1,
      proofDetails: json["proofDetails"] ?? "",
      gender: json["gender"] ?? "",
      proofType: json["proofType"] ?? "",
      status: json["status"] ?? "",
      guestMobile: json["guestMobile"] ?? "",
      purpose: json["purpose"] ?? "",
      visitorType: json["visitorType"] ?? "",
      checkedIn: json["checkedIn"] ?? "",
      fromAddress: json["fromAddress"] ?? "",
      checkedOut: json["checkedOut"] ?? "",
      image: json["image"] ?? "",
      visitorImages: [], // Initialize the images list
    );
  }
}
