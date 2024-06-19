// class InventoryModel {
//   String? status;
//   String? message;
//   List<Value>? value;

//   InventoryModel({this.status, this.message, this.value});

//   InventoryModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'] ?? "";
//     message = json['message'] ?? "";
//     if (json['value'] != null) {
//       value = <Value>[];
//       json['value'].forEach((v) {
//         value!.add(new Value.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['message'] = this.message;
//     if (this.value != null) {
//       data['value'] = this.value!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Value {
//   int? id;
//   String? goodsName;
//   String? quantity;
//   String? inTime;
//   String? checkedBy;
//   int? apartmentId;
//   String? movementType;

//   String? status;

//   Value(
//       {this.id,
//       this.goodsName,
//       this.quantity,
//       this.inTime,
//       this.checkedBy,
//       this.apartmentId,
//       this.movementType,
//       this.status});

//   Value.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     goodsName = json['goodsName'] ?? "";
//     quantity = json['quantity'] ?? "";
//     inTime = json['inTime'] ?? "";
//     checkedBy = json['checkedBy'] ?? "";
//     apartmentId = json['apartmentId'];
//     movementType = json['movementType']?? "";

//     status = json['status'] ?? "";
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['goodsName'] = this.goodsName;
//     data['quantity'] = this.quantity;
//     data['inTime'] = this.inTime;
//     data['checkedBy'] = this.checkedBy;
//     data['apartmentId'] = this.apartmentId;
//     data['movementType'] = this.movementType;

//     data['status'] = this.status;
//     return data;
//   }
// }

class InventoryModel {
  String? message;
  String? status;
  List<Value>? value;

  InventoryModel({this.message, this.status, this.value});

  InventoryModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['value'] != null) {
      value = <Value>[];
      json['value'].forEach((v) {
        value!.add(new Value.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.value != null) {
      data['value'] = this.value!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Value {
  int? id;
  String? goodsName;
  String? quantity;
  String? inTime;
  String? checkedBy;
  int? apartmentId;
  String? movementType;
  String? image;
  String? status;

  Value(
      {this.id,
      this.goodsName,
      this.quantity,
      this.inTime,
      this.checkedBy,
      this.apartmentId,
      this.movementType,
      this.image,
      this.status});

  Value.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    goodsName = json['goodsName'] ?? "";
    quantity = json['quantity'] ?? "";
    inTime = json['inTime'] ?? "";
    checkedBy = json['checkedBy'] ?? "";
    apartmentId = json['apartmentId'];
    movementType = json['movementType'] ?? "";
    image = json['image'] ?? "";
    status = json['status'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['goodsName'] = this.goodsName;
    data['quantity'] = this.quantity;
    data['inTime'] = this.inTime;
    data['checkedBy'] = this.checkedBy;
    data['apartmentId'] = this.apartmentId;
    data['movementType'] = this.movementType;
    data['image'] = this.image;
    data['status'] = this.status;
    return data;
  }
}
