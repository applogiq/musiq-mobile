import '../../../../constants/api.dart';

import '../../../../base_service/network/base_api_services.dart';
import '../../../../base_service/network/network_api_service.dart';

class ArtistRepo {
  BaseApiServices apiServices = NetworkApiService();

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
