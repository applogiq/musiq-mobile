class ForgotPasswordModel {
    ForgotPasswordModel({
        required this.success,
        required this.message,
    });

    final bool? success;
    final String? message;

    factory ForgotPasswordModel.fromJson(Map<String, dynamic> json){ 
        return ForgotPasswordModel(
        success: json["success"],
        message: json["message"],
    );
    }

}
