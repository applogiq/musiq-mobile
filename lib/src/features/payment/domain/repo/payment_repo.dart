import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/base_service/network/base_api_services.dart';
import '../../../../core/base_service/network/network_api_service.dart';
import '../../../../core/constants/api.dart';

class PaymentRepository {
  BaseApiServices apiServices = NetworkApiService();
  FlutterSecureStorage storage = const FlutterSecureStorage();
  Future<dynamic> getSubscriptionsPlan({limit = 100}) async {
    var subscriptionListUrl = APIConstants.subscriptionListEndPoint;

    try {
      dynamic response =
          await apiServices.getGetAuthApiResponse(subscriptionListUrl);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> createPayment(Map params) async {
    try {
      var userId = await storage.read(key: "id");

      params["user_id"] = int.parse(userId!);
      var endpoint = APIConstants.paymentCreateEndpoint;
      dynamic response =
          await apiServices.getPostAuthApiResponse(endpoint, params);
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
