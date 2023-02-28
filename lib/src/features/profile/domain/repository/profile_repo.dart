import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/base_service/network/base_api_services.dart';
import '../../../../core/base_service/network/network_api_service.dart';
import '../../../../core/constants/api.dart';

class ProfileRepository {
  BaseApiServices apiServices = NetworkApiService();
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();

// Update profile API call
  Future<dynamic> updateProfile(String id, Map params) async {
    try {
      dynamic response = await apiServices.getPutAuthApiResponse(
          APIConstants.kUpdateProfileEndPoint + id.toString(), params);
      return response;
    } catch (e) {
      rethrow;
    }
  }

// Get profile details API call
  Future<dynamic> getProfile() async {
    try {
      var id = await secureStorage.read(
        key: "id",
      );
      dynamic response = await apiServices.getGetAuthApiResponse(
        APIConstants.kUpdateProfileEndPoint + id.toString(),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

// Delete user image API call
  Future<dynamic> deleteUserImage(
    String id,
  ) async {
    try {
      dynamic response = await apiServices.getDeleteAuthApiResponse(
        APIConstants.kProfileImageDeleteEndPoint + id.toString(),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
