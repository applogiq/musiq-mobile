import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../base_service/network/base_api_services.dart';
import '../../../../base_service/network/network_api_service.dart';
import '../../../../constants/api.dart';

class LibraryRepo {
  BaseApiServices apiServices = NetworkApiService();
  FlutterSecureStorage storage = FlutterSecureStorage();
  Future<dynamic> getFavourite() async {
    try {
      var id = await storage.read(key: "id");
      dynamic response = await apiServices.getGetAuthApiResponse(
        APIConstants.BASE_URL + APIConstants.FAV + id.toString(),
      );
      return response;
    } catch (e) {
      throw e;
    }
  }
  //  getFavourites({int limit = 100}) async {

  //   var id = await storage.read(key: "id");
  //   //  var auraUrl=apiConstants.getAuraUrl(limit:limit);
  //   var res = await apiCall.getRequestWithAuth(
  //       APIConstants.BASE_URL + APIConstants.FAV + id.toString());

  //   if (res.statusCode == 200) {
  //     print(jsonDecode(res.body));
  //     Favourite favourite = Favourite.fromMap(jsonDecode(res.body));
  //     return favourite;
  //   } else {
  //     Favourite favourite =
  //         Favourite(success: false, message: "", records: [], totalRecords: 0);
  //     print(favourite);
  //     return favourite;
  //   }
  // }
}
