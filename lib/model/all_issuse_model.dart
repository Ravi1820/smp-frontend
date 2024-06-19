class AllIssueModel {
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

  AllIssueModel(
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

  AllIssueModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
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
        ? IssueCatagory.fromJson(json['issueCatagory'])
        : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    issuePriority = json['issuePriority'] != null
        ? IssuePriority.fromJson(json['issuePriority'])
        : null;
    issueStatus = json['issueStatus'] != null
        ? IssueStatus.fromJson(json['issueStatus'])
        : null;
    staffTeam = json['staffTeam'] != null
        ? StaffTeam.fromJson(json['staffTeam'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['issueUniqueId'] = issueUniqueId;
    data['residentId'] = residentId;
    data['issueType'] = issueType;
    data['description'] = description;
    data['catagoryId'] = catagoryId;
    data['createdTime'] = createdTime;
    data['resolvedTime'] = resolvedTime;
    data['picture'] = picture;
    data['assignedId'] = assignedId;
    data['priorityId'] = priorityId;
    data['statusId'] = statusId;
    data['response'] = response;
    data['privateNote'] = privateNote;
    data['apartmentId'] = apartmentId;
    if (issueCatagory != null) {
      data['issueCatagory'] = issueCatagory!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (issuePriority != null) {
      data['issuePriority'] = issuePriority!.toJson();
    }
    if (issueStatus != null) {
      data['issueStatus'] = issueStatus!.toJson();
    }
    if (staffTeam != null) {
      data['staffTeam'] = staffTeam!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['catagoryName'] = catagoryName;
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
    id = json['id'];
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['emailId'] = emailId;
    data['userName'] = userName;
    data['mobile'] = mobile;
    data['password'] = password;
    data['fullName'] = fullName;
    data['age'] = age;
    data['blockNumber'] = blockNumber;
    data['flatNumber'] = flatNumber;
    data['address'] = address;
    data['profilePicture'] = profilePicture;
    data['gender'] = gender;
    data['pinCode'] = pinCode;
    data['status'] = status;
    data['apartmentId'] = apartmentId;
    data['shiftStartTime'] = shiftStartTime;
    data['shiftEndTime'] = shiftEndTime;
    data['state'] = state;
    data['pushNotificationToken'] = pushNotificationToken;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['priorityName'] = priorityName;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['statusName'] = statusName;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['roleName'] = roleName;
    return data;
  }
}
