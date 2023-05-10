import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musiq/src/core/base_service/network/base_api_services.dart';
import 'package:musiq/src/core/base_service/network/network_api_service.dart';
import 'package:musiq/src/core/constants/api.dart';

class PodcastReposiory {
  BaseApiServices apiServices = NetworkApiService();
  FlutterSecureStorage storage = const FlutterSecureStorage();
  Future<dynamic> viewAllPodcast(int limit) async {
    try {
      var endpoint = APIConstants().getAllPodcasturl(limit);
      print(endpoint.toString());
      dynamic response = await apiServices.getGetAuthApiResponse(endpoint);
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> viewPodcastList(int limit, String id) async {
    // var podcastId = await storage.read(key: 'podcastKey');
    try {
      var endpoint = APIConstants().viewPodcastListUrl(limit, id.toString());
      print(endpoint.toString());
      dynamic response = await apiServices.getGetAuthApiResponse(endpoint);
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
