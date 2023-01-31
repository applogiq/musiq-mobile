import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../base_service/network/base_api_services.dart';
import '../../../../base_service/network/network_api_service.dart';
import '../../../../constants/api.dart';

class SearchRepository {
  BaseApiServices apiServices = NetworkApiService();
  FlutterSecureStorage storage = const FlutterSecureStorage();
  Future<dynamic> getArtistSearch(String data) async {
    try {
      // var userId = await storage.read(key: "register_id");
      var endpoint = APIConstants.searchArtist + data;
      dynamic response = await apiServices.getGetAuthApiResponse(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getSongSearch(String data) async {
    try {
      // var userId = await storage.read(key: "register_id");
      var endpoint = APIConstants.kSearchSong + data;
      print(endpoint);
      dynamic response = await apiServices.getGetAuthApiResponse(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
