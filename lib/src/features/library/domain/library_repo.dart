import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../base_service/network/base_api_services.dart';
import '../../../base_service/network/network_api_service.dart';
import '../../../constants/api.dart';

class LibraryRepository {
  BaseApiServices apiServices = NetworkApiService();
  FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<dynamic> getFavouritesList(String id) async {
    try {
      dynamic response = await apiServices.getGetAuthApiResponse(
        APIConstants.kFavouriteList + id,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

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

  Future<dynamic> getPlayListdata(String id) async {
    try {
      dynamic response = await apiServices.getGetAuthApiResponse(
        APIConstants.kPlayList + id,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> createPlaylist(Map params) async {
    try {
      dynamic response = await apiServices.getPostAuthApiResponse(
          APIConstants.kCreatePlayList, params);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> updatePlaylistName(Map params, int id) async {
    try {
      dynamic response = await apiServices.getPutAuthApiResponse(
          APIConstants.kCreatePlayList + id.toString(), params);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> deletePlaylist(String id) async {
    try {
      dynamic response = await apiServices.getDeleteAuthApiResponse(
        APIConstants.kCreatePlayList + id.toString(),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> deletePlaylistSong(String id) async {
    try {
      dynamic response = await apiServices.getDeleteAuthApiResponse(
        APIConstants.kPlaylistSong + id.toString(),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getPlayListSongListdata(String id) async {
    try {
      dynamic response = await apiServices.getGetAuthApiResponse(
        APIConstants.kPlaylistSongList + id,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
