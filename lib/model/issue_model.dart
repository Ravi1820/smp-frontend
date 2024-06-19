class IssueModel {
  final int id;
  final String issueMessage;
  final int flatNumber;
  final int floorNumber;
  final int blockNumber;
  final String status;
  final String action;

  IssueModel({
    required this.id,
    required this.issueMessage,
    required this.flatNumber,
    required this.floorNumber,
    required this.blockNumber,
    required this.status,
    required this.action,
  });

  factory IssueModel.fromJson(Map<String, dynamic> json) {
    return IssueModel(
      id: json['id'],
      issueMessage: json['issueMessage'],
      flatNumber: json['flatNumber'],
      floorNumber: json['floorNumber'],
      blockNumber: json['blockNumber'],
      status: json['status'],
      action: json['action'],
    );
  }
}
