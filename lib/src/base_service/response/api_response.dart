import 'status.dart';

class ApiResponse<T> {
  ApiResponse(this.status, this.data, this.message);

  ApiResponse.completed(this.data) : status = Status.completed;

  ApiResponse.error(this.message) : status = Status.error;

  ApiResponse.loading() : status = Status.loading;

  T? data;
  String? message;
  Status? status;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data: $data";
  }
}
