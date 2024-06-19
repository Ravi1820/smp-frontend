class AdminResolvedIssueModel {
  int? id;
  String? issueUniqueId;
  int? residentId;
  String? issueType;
  String? description;
  int? catagoryId;
  String? createdTime;
  String? resolvedTime;
  String? picture;
  int? assignedId;
  int? priorityId;
  int? statusId;
  String? response;
  String? privateNote;
  int? apartmentId;
  IssueCatagory? issueCatagory;
  User? user;
  IssuePriority? issuePriority;
  IssueStatus? issueStatus;
  StaffTeam? staffTeam;

  AdminResolvedIssueModel(
      {this.id,
      this.issueUniqueId,
      this.residentId,
      this.issueType,
      this.description,
      this.catagoryId,
      this.createdTime,
      this.resolvedTime,
      this.picture,
      this.assignedId,
      this.priorityId,
      this.statusId,
      this.response,
      this.privateNote,
      this.apartmentId,
      this.issueCatagory,
      this.user,
      this.issuePriority,
      this.issueStatus,
      this.staffTeam});

  AdminResolvedIssueModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    issueUniqueId = json['issueUniqueId'] ?? "";
    residentId = json['residentId'] ?? 0;
    issueType = json['issueType'] ?? "";
    description = json['description'] ?? "";
    catagoryId = json['catagoryId'] ?? 0;
    createdTime = json['createdTime'] ?? "";
    resolvedTime = json['resolvedTime'] ?? "";
    picture = json['picture'] ?? "";
    assignedId = json['assignedId'] ?? 0;
    priorityId = json['priorityId'] ?? 0;
    statusId = json['statusId'] ?? 0;
    response = json['response'] ?? "";
    privateNote = json['privateNote'] ?? "";
    apartmentId = json['apartmentId'] ?? 0;
    issueCatagory = json['issueCatagory'] != null
        ? new IssueCatagory.fromJson(json['issueCatagory'])
        : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    issuePriority = json['issuePriority'] != null
        ? new IssuePriority.fromJson(json['issuePriority'])
        : null;
    issueStatus = json['issueStatus'] != null
        ? new IssueStatus.fromJson(json['issueStatus'])
        : null;
    staffTeam = json['staffTeam'] != null
        ? new StaffTeam.fromJson(json['staffTeam'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['issueUniqueId'] = this.issueUniqueId;
    data['residentId'] = this.residentId;
    data['issueType'] = this.issueType;
    data['description'] = this.description;
    data['catagoryId'] = this.catagoryId;
    data['createdTime'] = this.createdTime;
    data['resolvedTime'] = this.resolvedTime;
    data['picture'] = this.picture;
    data['assignedId'] = this.assignedId;
    data['priorityId'] = this.priorityId;
    data['statusId'] = this.statusId;
    data['response'] = this.response;
    data['privateNote'] = this.privateNote;
    data['apartmentId'] = this.apartmentId;
    if (this.issueCatagory != null) {
      data['issueCatagory'] = this.issueCatagory!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.issuePriority != null) {
      data['issuePriority'] = this.issuePriority!.toJson();
    }
    if (this.issueStatus != null) {
      data['issueStatus'] = this.issueStatus!.toJson();
    }
    if (this.staffTeam != null) {
      data['staffTeam'] = this.staffTeam!.toJson();
    }
    return data;
  }
}

class IssueCatagory {
  int? id;
  String? catagoryName;

  IssueCatagory({this.id, this.catagoryName});

  IssueCatagory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    catagoryName = json['catagoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['catagoryName'] = this.catagoryName;
    return data;
  }
}

class User {
  int? id;
  String? emailId;
  String? userName;
  String? mobile;
  String? password;
  String? fullName;
  String? age;
  String? blockNumber;
  String? flatNumber;
  String? address;
  String? profilePicture;
  String? gender;
  String? pinCode;
  String? status;
  int? apartmentId;
  String? shiftStartTime;
  String? shiftEndTime;
  String? state;
  String? pushNotificationToken;

  User(
      {this.id,
      this.emailId,
      this.userName,
      this.mobile,
      this.password,
      this.fullName,
      this.age,
      this.blockNumber,
      this.flatNumber,
      this.address,
      this.profilePicture,
      this.gender,
      this.pinCode,
      this.status,
      this.apartmentId,
      this.shiftStartTime,
      this.shiftEndTime,
      this.state,
      this.pushNotificationToken});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    emailId = json['emailId'] ?? "";
    userName = json['userName'] ?? "";
    mobile = json['mobile'] ?? "";
    password = json['password'] ?? "";
    fullName = json['fullName'] ?? "";
    age = json['age'] ?? "";
    blockNumber = json['blockNumber'] ?? "";
    flatNumber = json['flatNumber'] ?? "";
    address = json['address'] ?? "";
    profilePicture = json['profilePicture'] ?? "";
    gender = json['gender'] ?? "";
    pinCode = json['pinCode'] ?? "";
    status = json['status'] ?? "";
    apartmentId = json['apartmentId'] ?? 0;
    shiftStartTime = json['shiftStartTime'] ?? "";
    shiftEndTime = json['shiftEndTime'] ?? "";
    state = json['state'] ?? "";
    pushNotificationToken = json['pushNotificationToken'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['emailId'] = this.emailId;
    data['userName'] = this.userName;
    data['mobile'] = this.mobile;
    data['password'] = this.password;
    data['fullName'] = this.fullName;
    data['age'] = this.age;
    data['blockNumber'] = this.blockNumber;
    data['flatNumber'] = this.flatNumber;
    data['address'] = this.address;
    data['profilePicture'] = this.profilePicture;
    data['gender'] = this.gender;
    data['pinCode'] = this.pinCode;
    data['status'] = this.status;
    data['apartmentId'] = this.apartmentId;
    data['shiftStartTime'] = this.shiftStartTime;
    data['shiftEndTime'] = this.shiftEndTime;
    data['state'] = this.state;
    data['pushNotificationToken'] = this.pushNotificationToken;
    return data;
  }
}

class IssuePriority {
  int? id;
  String? priorityName;

  IssuePriority({this.id, this.priorityName});

  IssuePriority.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    priorityName = json['priorityName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['priorityName'] = this.priorityName;
    return data;
  }
}

class IssueStatus {
  int? id;
  String? statusName;

  IssueStatus({this.id, this.statusName});

  IssueStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    statusName = json['statusName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['statusName'] = this.statusName;
    return data;
  }
}

class StaffTeam {
  int? id;
  String? roleName;

  StaffTeam({this.id, this.roleName});

  StaffTeam.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleName = json['roleName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['roleName'] = this.roleName;
    return data;
  }
}
