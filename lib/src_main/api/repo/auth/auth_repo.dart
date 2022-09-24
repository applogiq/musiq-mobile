import 'package:musiq/src/constants/api.dart';

import '../../network/base_api_services.dart';
import '../../network/network_api_service.dart';

class AuthRepository {
  BaseApiServices apiServices = NetworkApiService();
  Future<dynamic> login(params) async {
    try {
      dynamic response = await apiServices.getPostApiResponse(
          "https://api-musiq.applogiq.org/api/v1/users/login", params);
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> register(params) async {
    try {
      dynamic response = await apiServices.getPostApiResponse(
          "https://api-musiq.applogiq.org/api/v1/users/register", params);
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> getArtists({limit = 100}) async {
    var artistUrl = APIConstants().getArtistUrl(0, limit);
    try {
      dynamic response = await apiServices
          .getGetAuthApiResponse(APIConstants.BASE_URL + artistUrl);
      return response;
    } catch (e) {
      throw e;
    }
  }

  //  Future<ArtistModel> getArtist({int limit = 100}) async {
  //   var artistUrl = apiConstants.getArtistUrl(0, limit);

  //   var res = await apiCall.getRequestWithAuth(
  //     APIConstants.BASE_URL + artistUrl,
  //   );
  //   var data = jsonDecode(res.body);
  //   print(data.toString());
  //   ArtistModel artistModel = ArtistModel.fromMap(data);

  //   return artistModel;
  // }
}
