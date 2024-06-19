



class OwnerModel {
    int id;
    int roleId;
    int userId;
    List<Role> roles;
    User user;

    OwnerModel({
        required this.id,
        required this.roleId,
        required this.userId,
        required this.roles,
        required this.user,
    });

    factory OwnerModel.fromJson(Map<String, dynamic> json) => OwnerModel(
        id: json["id"],
        roleId: json["roleId"],
        userId: json["userId"],
        roles: List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "roleId": roleId,
        "userId": userId,
        "roles": List<dynamic>.from(roles.map((x) => x.toJson())),
        "user": user.toJson(),
    };
}

class Role {
    int id;
    String roleName;
    bool isActive;

    Role({
        required this.id,
        required this.roleName,
        required this.isActive,
    });

    factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        roleName: json["roleName"],
        isActive: json["isActive"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "roleName": roleName,
        "isActive": isActive,
    };
}

class User {
    int id;
    String emailId;
    String userName;
    String mobile;
    String password;
    String fullName;
    String age;
    String blockNumber;
    String flatNumber;
    String address;
    String profilePicture;
    String gender;
    dynamic pinCode;
    String status;
    int apartmentId;
    dynamic lastLogin;
    dynamic shiftStartTime;
    dynamic shiftEndTime;
    dynamic state;
    Apartment apartment;
    String pushNotificationToken;

    User({
        required this.id,
        required this.emailId,
        required this.userName,
        required this.mobile,
        required this.password,
        required this.fullName,
        required this.age,
        required this.blockNumber,
        required this.flatNumber,
        required this.address,
        required this.profilePicture,
        required this.gender,
        required this.pinCode,
        required this.status,
        required this.apartmentId,
        required this.lastLogin,
        required this.shiftStartTime,
        required this.shiftEndTime,
        required this.state,
        required this.apartment,
        required this.pushNotificationToken,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        emailId: json["emailId"],
        userName: json["userName"],
        mobile: json["mobile"],
        password: json["password"],
        fullName: json["fullName"],
        age: json["age"],
        blockNumber: json["blockNumber"],
        flatNumber: json["flatNumber"],
        address: json["address"],
        profilePicture: json["profilePicture"],
        gender: json["gender"],
        pinCode: json["pinCode"],
        status: json["status"],
        apartmentId: json["apartmentId"],
        lastLogin: json["lastLogin"],
        shiftStartTime: json["shiftStartTime"],
        shiftEndTime: json["shiftEndTime"],
        state: json["state"],
        apartment: Apartment.fromJson(json["apartment"]),
        pushNotificationToken: json["pushNotificationToken"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "emailId": emailId,
        "userName": userName,
        "mobile": mobile,
        "password": password,
        "fullName": fullName,
        "age": age,
        "blockNumber": blockNumber,
        "flatNumber": flatNumber,
        "address": address,
        "profilePicture": profilePicture,
        "gender": gender,
        "pinCode": pinCode,
        "status": status,
        "apartmentId": apartmentId,
        "lastLogin": lastLogin,
        "shiftStartTime": shiftStartTime,
        "shiftEndTime": shiftEndTime,
        "state": state,
        "apartment": apartment.toJson(),
        "pushNotificationToken": pushNotificationToken,
    };
}

class Apartment {
    int id;
    String name;
    String emailId;
    String mobile;
    String landline;
    String address1;
    String address2;
    String profilePicture;
    String state;
    int pinCode;
    String country;
    String status;

    Apartment({
        required this.id,
        required this.name,
        required this.emailId,
        required this.mobile,
        required this.landline,
        required this.address1,
        required this.address2,
        required this.profilePicture,
        required this.state,
        required this.pinCode,
        required this.country,
        required this.status,
    });

    factory Apartment.fromJson(Map<String, dynamic> json) => Apartment(
        id: json["id"],
        name: json["name"],
        emailId: json["emailId"],
        mobile: json["mobile"],
        landline: json["landline"],
        address1: json["address_1"],
        address2: json["address_2"],
        profilePicture: json["profilePicture"],
        state: json["state"],
        pinCode: json["pinCode"],
        country: json["country"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "emailId": emailId,
        "mobile": mobile,
        "landline": landline,
        "address_1": address1,
        "address_2": address2,
        "profilePicture": profilePicture,
        "state": state,
        "pinCode": pinCode,
        "country": country,
        "status": status,
    };
}

