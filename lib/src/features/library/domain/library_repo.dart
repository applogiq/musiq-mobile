import '../../../base_service/network/base_api_services.dart';
import '../../../base_service/network/network_api_service.dart';
import '../../../constants/api.dart';

class LibraryRepository {
  BaseApiServices apiServices = NetworkApiService();

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
}
