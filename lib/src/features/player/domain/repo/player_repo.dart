import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../base_service/network/base_api_services.dart';
import '../../../../base_service/network/network_api_service.dart';
import '../../../../constants/api.dart';

class PlayerRepo {
  BaseApiServices apiServices = NetworkApiService();
  FlutterSecureStorage storage = const FlutterSecureStorage();
  Future<dynamic> addToFavourite(Map params) async {
    try {
      var id = await storage.read(key: "id");
      params["user_id"] = id;
      dynamic response = await apiServices.getPostAuthApiResponse(
          APIConstants.kFavourite, params);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
