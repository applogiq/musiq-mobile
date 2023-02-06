import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

import '../app_exceptions.dart';
import 'base_api_services.dart';

class NetworkApiService extends BaseApiServices {
  //? Header
  var header = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  var storage = const FlutterSecureStorage();

  @override
  Future getDeleteAuthApiResponse(String url) async {
    dynamic responseJson;
    try {
      var token = await storage.read(key: "access_token");

      header["Authorization"] = "Bearer $token";

      Response response = await delete(
        Uri.parse(url),
        headers: header,
      ).timeout(const Duration(seconds: 30));

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  @override
  Future getDeleteAuthWithDataApiResponse(String url, data) async {
    dynamic responseJson;
    try {
      var token = await storage.read(key: "access_token");

      header["Authorization"] = "Bearer $token";

      Response response =
          await delete(Uri.parse(url), headers: header, body: jsonEncode(data));

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  @override
  Future getGetApiResponse(String url) async {
    dynamic responseJson;
    try {
      final response =
          await get(Uri.parse(url)).timeout(const Duration(seconds: 30));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  @override
  Future getGetAuthApiResponse(String url) async {
    dynamic responseJson;
    try {
      var token = await storage.read(key: "access_token");

      header["Authorization"] = "Bearer $token";

      Response response = await get(
        Uri.parse(url),
        headers: header,
      ).timeout(const Duration(seconds: 30));

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      Response response =
          await post(Uri.parse(url), headers: header, body: jsonEncode(data));

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  @override
  Future getPostAuthApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      var token = await storage.read(key: "access_token");

      header["Authorization"] = "Bearer $token";

      Response response =
          await post(Uri.parse(url), headers: header, body: jsonEncode(data))
              .timeout(const Duration(seconds: 30));

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  @override
  Future getPutAuthApiResponse(String url, data) async {
    dynamic responseJson;
    try {
      var token = await storage.read(key: "access_token");

      header["Authorization"] = "Bearer $token";

      Response response =
          await put(Uri.parse(url), headers: header, body: jsonEncode(data))
              .timeout(const Duration(seconds: 30));

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  @override
  Future getPuthtApiResponse(String url, data) async {
    dynamic responseJson;
    try {
      Response response =
          await put(Uri.parse(url), headers: header, body: jsonEncode(data));

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  dynamic returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return response;
      case 404:
        return response;
      case 400:
        return response;
      case 500:
      case 403:
        throw UnauthorisedException(response.body.toString());
      default:
        return response;
    }
  }
}
