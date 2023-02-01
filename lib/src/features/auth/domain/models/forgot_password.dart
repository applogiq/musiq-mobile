class ForgotPasswordModel {
  ForgotPasswordModel({
    required this.success,
    required this.message,
  });

  factory ForgotPasswordModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordModel(
      success: json["success"],
      message: json["message"],
    );
  }

  final String? message;
  final bool? success;
}
