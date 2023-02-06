import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/base_service/network/base_api_services.dart';
import '../../../../core/base_service/network/network_api_service.dart';
import '../../../../core/constants/api.dart';

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

  Future<dynamic> deleteFavourite(Map params) async {
    try {
      var id = await storage.read(key: "id");
      params["user_id"] = id;
      dynamic response = await apiServices.getDeleteAuthWithDataApiResponse(
          APIConstants.kFavourite, params);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> addToPlaylist(Map params) async {
    try {
      dynamic response = await apiServices.getPostAuthApiResponse(
          APIConstants.kPlaylistSong, params);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> recentList(Map params) async {
    try {
      var id = await storage.read(key: "register_id");
      params["user_id"] = id;
      dynamic response = await apiServices.getPutAuthApiResponse(
          APIConstants.kRecentPlayedList, params);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> songInfo(String id) async {
    try {
      var url = APIConstants.kSongs + id;
      dynamic response = await apiServices.getGetAuthApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
