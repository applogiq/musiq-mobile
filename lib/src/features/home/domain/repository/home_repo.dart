import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musiq/src/constants/api.dart';

import '../../../../base_service/network/base_api_services.dart';
import '../../../../base_service/network/network_api_service.dart';

class HomeRepository {
  BaseApiServices apiServices = NetworkApiService();
  FlutterSecureStorage storage = const FlutterSecureStorage();
  Future<dynamic> getRecentPlayedList(int limit) async {
    try {
      var userId = await storage.read(key: "register_id");
      var endpoint = APIConstants().getRecentlyPlayedUrl(userId!, limit);
      dynamic response = await apiServices.getGetAuthApiResponse(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getTrendingSongList(int limit) async {
    try {
      var endpoint = APIConstants().getTrendingHitsUrl(limit: limit);
      dynamic response = await apiServices.getGetAuthApiResponse(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getAura() async {
    try {
      var endpoint = APIConstants.kAuraList;
      dynamic response = await apiServices.getGetAuthApiResponse(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getSpecificAura(int id) async {
    try {
      var endpoint = APIConstants.kAuraSongList + id.toString();
      dynamic response = await apiServices.getGetAuthApiResponse(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getArtist({int limit = 100}) async {
    try {
      var endpoint = APIConstants.getArtistUrl(0, limit);
      dynamic response = await apiServices.getGetAuthApiResponse(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getAlbum() async {
    try {
      var endpoint = APIConstants.kAlbumList;
      dynamic response = await apiServices.getGetAuthApiResponse(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getSpecificAlbum(int id) async {
    try {
      var endpoint = APIConstants.kAlbumSongList + id.toString();
      dynamic response = await apiServices.getGetAuthApiResponse(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getSpecifArtistSong(String artistId) async {
    try {
      var endpoint = APIConstants.getSpecificArtistUrl(artistId);
      dynamic response = await apiServices.getGetAuthApiResponse(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  getNewRelease() async {
    try {
      var endpoint = APIConstants.kNewRelease;
      dynamic response = await apiServices.getGetAuthApiResponse(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
