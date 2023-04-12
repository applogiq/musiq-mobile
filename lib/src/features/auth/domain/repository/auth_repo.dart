import 'dart:developer';

import '../../../../core/base_service/network/base_api_services.dart';
import '../../../../core/base_service/network/network_api_service.dart';
import '../../../../core/constants/api.dart';

class AuthRepository {
  BaseApiServices apiServices = NetworkApiService();
// Login API call
  Future<dynamic> login(params) async {
    log(APIConstants.kLoginEndPoint.toString());
    log(APIConstants.kLoginEndPoint.toString());
    log(APIConstants.kLoginEndPoint.toString());
    log(APIConstants.kLoginEndPoint.toString());
    log(APIConstants.kLoginEndPoint.toString());
    log(APIConstants.kLoginEndPoint.toString());
    log(APIConstants.kLoginEndPoint.toString());
    log(APIConstants.kLoginEndPoint.toString());
    log(APIConstants.kLoginEndPoint.toString());
    log(APIConstants.kLoginEndPoint.toString());
    log(APIConstants.kLoginEndPoint.toString());
    log(APIConstants.kLoginEndPoint.toString());
    log(APIConstants.kLoginEndPoint.toString());
    log(params.toString());
    try {
      dynamic response = await apiServices.getPostApiResponse(
          APIConstants.kLoginEndPoint, params);

      return response;
    } catch (e) {
      rethrow;
    }
  }

// Register API call
  Future<dynamic> register(params) async {
    try {
      dynamic response = await apiServices.getPostApiResponse(
          APIConstants.kRegisterEndPoint, params);
      return response;
    } catch (e) {
      rethrow;
    }
  }

// Get artist list API
  Future<dynamic> getArtists({limit = 100}) async {
    var artistUrl = APIConstants.getArtistUrl(0, limit);

    try {
      dynamic response = await apiServices.getGetAuthApiResponse(artistUrl);
      return response;
    } catch (e) {
      rethrow;
    }
  }

// Email verfication API call
  emailVerfication(Map params) async {
    try {
      dynamic response = await apiServices.getPostApiResponse(
          APIConstants.kEmailVerficationEndPoint, params);
      return response;
    } catch (e) {
      rethrow;
    }
  }

// OTP verfication API call
  otpVerfication(Map params) async {
    try {
      dynamic response = await apiServices.getPostApiResponse(
          APIConstants.kOTPVerficationEndPoint, params);
      return response;
    } catch (e) {
      rethrow;
    }
  }

// Password change API call
  passwordChanged(Map params) async {
    try {
      dynamic response = await apiServices.getPutApiResponse(
          APIConstants.kPasswordChangeEndPoint, params);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
