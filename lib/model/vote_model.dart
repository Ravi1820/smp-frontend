class VoteModel {
  final int id;

  final String voteFor;
  final String responseMsg;

  final List<String> options;
  final DateTime startDate;
  final DateTime endDate;
  final bool voted;
  bool? isChecked = false;

  VoteModel({
    required this.id,
    required this.voteFor,
    required this.responseMsg,
    required this.options,
    required this.startDate,
    required this.endDate,
    required this.voted,
    this.isChecked,
  });

  factory VoteModel.fromJson(Map<String, dynamic> json) {
    List<String> options = [];
    if (json['options'] is List) {
      options = List<String>.from(json['options']);
    }

    return VoteModel(
      id: json['id'] as int,
      voteFor: json['voteFor'] as String,
      responseMsg: json['responseMsg'] as String? ?? '', 
      options: options,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      voted: json['voted'] ?? false,
    );
  }
}













// // class VoteModel {
// //   final int id;

// //   final String voteFor;
// //   final String responseMsg;

// //   final List<String> options;
// //   final DateTime startDate;
// //   final DateTime endDate;
// //   final bool voted;
// //   bool? isChecked = false;

// //   VoteModel({
// //     required this.id,
// //     required this.voteFor,
// //     required this.responseMsg,
// //     required this.options,
// //     required this.startDate,
// //     required this.endDate,
// //     required this.voted,
// //     this.isChecked,
// //   });

// //   factory VoteModel.fromJson(Map<String, dynamic> json) {
// //     List<String> options = [];
// //     if (json['options'] is List) {
// //       options = List<String>.from(json['options']);
// //     }

// //     return VoteModel(
// //       id: json['id'] as int,
// //       voteFor: json['voteFor'] as String,
// //       responseMsg: json['responseMsg'] as String? ?? '', // Handle null case
// //       options: options,
// //       startDate: DateTime.parse(json['startDate'] as String),
// //       endDate: DateTime.parse(json['endDate'] as String),
// //       voted: json['voted'] ?? false,
// //     );
// //   }
// // }

// class VoteModel {
//   int id;
//   String voteFor;
//   List<String> options;
//   DateTime startDate;
//   DateTime endDate;
//   String responseMsg;
//   String votePollStatus;
//   bool voted;
//   bool? isChecked = false;
//   VoteModel({
//     required this.id,
//     required this.voteFor,
//     required this.options,
//     required this.startDate,
//     required this.endDate,
//     required this.responseMsg,
//     required this.votePollStatus,
//     required this.voted,
//     this.isChecked,
//   });

//   factory VoteModel.fromJson(Map<String, dynamic> json) {
//     List<String> options = [];
//     if (json['options'] is List) {
//       options = List<String>.from(json['options']);
//     }

//     return VoteModel(
//       id: json['id'] as int,
//       voteFor: json['voteFor'] as String,
//       responseMsg: json['responseMsg'] as String? ?? '',
//       options: options,
//       startDate: DateTime.parse(json['startDate'] as String),
//       endDate: DateTime.parse(json['endDate'] as String),
//       voted: json['voted'] ?? false,
//       votePollStatus: json['votePollStatus'] as String? ?? '',
//     );
//   }

//   // VoteModel.fromJson(Map<String, dynamic> json) {
//   //   id = json['id'];
//   //   voteFor = json['voteFor'];
//   //   options = json['options'].cast<String>();
//   //   startDate = json['startDate'];
//   //   endDate = json['endDate'];
//   //   responseMsg = json['responseMsg'];
//   //   votePollStatus = json['votePollStatus'];
//   //   voted = json['voted'];
//   // }

//   // Map<String, dynamic> toJson() {
//   //   final Map<String, dynamic> data = new Map<String, dynamic>();
//   //   data['id'] = this.id;
//   //   data['voteFor'] = this.voteFor;
//   //   data['options'] = this.options;
//   //   data['startDate'] = this.startDate;
//   //   data['endDate'] = this.endDate;
//   //   data['responseMsg'] = this.responseMsg;
//   //   data['votePollStatus'] = this.votePollStatus;
//   //   data['voted'] = this.voted;
//   //   return data;
//   // }
// }




