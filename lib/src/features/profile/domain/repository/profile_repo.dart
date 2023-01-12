import 'package:musiq/src/constants/api.dart';

import '../../../../base_service/network/base_api_services.dart';
import '../../../../base_service/network/network_api_service.dart';

class ProfileRepository {
  BaseApiServices apiServices = NetworkApiService();
  Future<dynamic> updateProfile(String id, Map params) async {
    try {
      dynamic response = await apiServices.getPutAuthApiResponse(
          APIConstants.kUpdateProfileEndPoint + id.toString(), params);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getProfile(
    String id,
  ) async {
    try {
      dynamic response = await apiServices.getGetAuthApiResponse(
        APIConstants.kUpdateProfileEndPoint + id.toString(),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
