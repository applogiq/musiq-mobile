abstract class BaseApiServices {
  Future<dynamic> getGetApiResponse(String url);

  Future<dynamic> getPostApiResponse(String url, dynamic data);
  Future<dynamic> getPuthtApiResponse(String url, dynamic data);
  Future<dynamic> getPostAuthApiResponse(String url, dynamic data);
  Future<dynamic> getPutAuthApiResponse(String url, dynamic data);
  Future<dynamic> getGetAuthApiResponse(String url);
  Future<dynamic> getDeleteAuthApiResponse(String url);
}
