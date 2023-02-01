class AppException implements Exception {
  AppException({required this.message, required this.prefix});

  final String message;
  final String prefix;

  @override
  String toString() {
    return '$prefix$message';
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(
            message: message.toString(), prefix: 'Error During Communication');
}

class BadRequestException extends AppException {
  BadRequestException([String? message])
      : super(message: message.toString(), prefix: 'Invalid request');
}

class UnauthorisedException extends AppException {
  UnauthorisedException([String? message])
      : super(message: message.toString(), prefix: 'Unauthorised request');
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message])
      : super(message: message.toString(), prefix: 'Invalid Inpit');
}
