import 'package:musiq/src/constants/api.dart';

import '../../../../base_service/network/base_api_services.dart';
import '../../../../base_service/network/network_api_service.dart';

class ArtistRepo {
  BaseApiServices apiServices = NetworkApiService();
  Future<dynamic> followAndUnfollow(params) async {
    try {
      dynamic response = await apiServices.getPutAuthApiResponse(
          APIConstants.BASE_URL + APIConstants.ARTIST_FOLLOWING, params);
      return response;
    } catch (e) {
      throw e;
    }
  }
}
