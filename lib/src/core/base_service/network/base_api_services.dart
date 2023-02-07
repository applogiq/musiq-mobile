abstract class BaseApiServices {
  //Method declaration for get api
  Future<dynamic> getGetApiResponse(String url);

  //Method declaration for post api
  Future<dynamic> getPostApiResponse(String url, dynamic data);

  //Method declaration for put api
  Future<dynamic> getPutApiResponse(String url, dynamic data);

  //Method declaration for post authentication api
  Future<dynamic> getPostAuthApiResponse(String url, dynamic data);

  //Method declaration for put authentication api
  Future<dynamic> getPutAuthApiResponse(String url, dynamic data);

  //Method declaration for get authentication api
  Future<dynamic> getGetAuthApiResponse(String url);

  //Method declaration for delete authentication api
  Future<dynamic> getDeleteAuthApiResponse(String url);

  //Method declaration for delete authentication api with request body
  Future<dynamic> getDeleteAuthWithDataApiResponse(String url, dynamic data);
}
