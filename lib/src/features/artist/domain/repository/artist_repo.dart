import '../../../../core/base_service/network/base_api_services.dart';
import '../../../../core/base_service/network/network_api_service.dart';
import '../../../../core/constants/api.dart';

class ArtistRepo {
  BaseApiServices apiServices = NetworkApiService();

  // Follow and unfollow API call
  Future<dynamic> followAndUnfollow(params) async {
    try {
      dynamic response = await apiServices.getPutAuthApiResponse(
          APIConstants.kArtistFollowing, params);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
