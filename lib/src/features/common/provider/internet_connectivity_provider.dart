import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetConnectivityProvider extends ChangeNotifier {
  InternetConnectivityProvider() {
    checkRealtimeConnection();
  }
  bool isNetworkAvailable = true;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription streamSubscription;

  void checkConnectivity() async {
    var connectionResult = await _connectivity.checkConnectivity();
    if (connectionResult == ConnectivityResult.mobile ||
        connectionResult == ConnectivityResult.wifi) {
      isNetworkAvailable = true;
      notifyListeners();
    } else {
      isNetworkAvailable = false;
      notifyListeners();
    }
  }

  void checkRealtimeConnection() {
    debugPrint("network");
    streamSubscription = _connectivity.onConnectivityChanged.listen((event) {
      debugPrint(event.toString());
      switch (event) {
        case ConnectivityResult.mobile:
          {
            debugPrint("true");

            isNetworkAvailable = true;
            notifyListeners();
          }
          break;
        case ConnectivityResult.wifi:
          {
            isNetworkAvailable = true;
            debugPrint("true");

            notifyListeners();
          }
          break;
        default:
          {
            isNetworkAvailable = false;
            debugPrint("false");

            notifyListeners();
          }
          break;
      }
    });
    debugPrint("MACHO");
  }
}
