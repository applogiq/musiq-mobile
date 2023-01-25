// import 'dart:async';

// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';

// class InternetConnectivityProvider extends ChangeNotifier {
//   InternetConnectivityProvider() {
//     checkRealtimeConnection();
//   }
//   bool isNetworkAvailable = true;
//   final Connectivity _connectivity = Connectivity();
//   late StreamSubscription _streamSubscription;

//   void checkConnectivity() async {
//     var connectionResult = await _connectivity.checkConnectivity();
//     if (connectionResult == ConnectivityResult.mobile ||
//         connectionResult == ConnectivityResult.wifi) {
//       isNetworkAvailable = true;
//       notifyListeners();
//     } else {
//       isNetworkAvailable = false;
//       notifyListeners();
//     }
//   }

//   void checkRealtimeConnection() {
//     print("network");
//     _streamSubscription = _connectivity.onConnectivityChanged.listen((event) {
//       print(event);
//       switch (event) {
//         case ConnectivityResult.mobile:
//           {
//             print("true");

//             isNetworkAvailable = true;
//             notifyListeners();
//           }
//           break;
//         case ConnectivityResult.wifi:
//           {
//             isNetworkAvailable = true;
//             print("true");

//             notifyListeners();
//           }
//           break;
//         default:
//           {
//             isNetworkAvailable = false;
//             print("false");

//             notifyListeners();
//           }
//           break;
//       }
//     });
//     print("MACHO");
//   }
// }
