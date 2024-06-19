class ResidentVisitorsModel {
  final String visitorName;
  final int id;
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

  ResidentVisitorsModel({
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
  });

  factory ResidentVisitorsModel.fromJson(Map<String, dynamic> json) {
    return ResidentVisitorsModel(
      visitorName: json["visitorName"] ?? "Unknown",
      id: json["id"] ?? -1,
      residentId: json["residentId"] ?? -1,
      proofDetails: json["proofDetails"] ?? "Unknown",
      gender: json["gender"] ?? "Unknown",
      proofType: json["proofType"] ?? "Unknown",
      status: json["status"] ?? "Unknown",
      guestMobile: json["guestMobile"] ?? "Unknown",
      purpose: json["purpose"] ?? "Unknown",
      visitorType: json["visitorType"] ?? "Unknown",
      checkedIn: json["checkedIn"] ?? "Unknown",
      fromAddress: json["fromAddress"] ?? "Unknown",
      checkedOut: json["checkedOut"] ?? "Unknown",
    );
  }
}
