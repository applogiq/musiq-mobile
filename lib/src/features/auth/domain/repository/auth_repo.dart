import '../../../../core/base_service/network/base_api_services.dart';
import '../../../../core/base_service/network/network_api_service.dart';
import '../../../../core/constants/api.dart';

class AuthRepository {
  BaseApiServices apiServices = NetworkApiService();

  Future<dynamic> login(params) async {
    try {
      dynamic response = await apiServices.getPostApiResponse(
          APIConstants.kLoginEndPoint, params);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> register(params) async {
    try {
      dynamic response = await apiServices.getPostApiResponse(
          APIConstants.kRegisterEndPoint, params);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getArtists({limit = 100}) async {
    var artistUrl = APIConstants.getArtistUrl(0, limit);

    try {
      dynamic response = await apiServices.getGetAuthApiResponse(artistUrl);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  emailVerfication(Map params) async {
    try {
      dynamic response = await apiServices.getPostApiResponse(
          APIConstants.kEmailVerficationEndPoint, params);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  otpVerfication(Map params) async {
    try {
      dynamic response = await apiServices.getPostApiResponse(
          APIConstants.kOTPVerficationEndPoint, params);
      return response;
    } catch (e) {
      rethrow;
    }
  }

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
