
// Define a model class to represent the JSON structure
class ErrorResponseModel {
  final String message;
  final String status;

  ErrorResponseModel({
    required this.message,
    required this.status,
  });

  factory ErrorResponseModel.fromJson(Map<String, dynamic> json) {
    return ErrorResponseModel(
      message: json['message'],
      status: json['status'],
    );
  }
}
