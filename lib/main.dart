import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/config/theme.dart';
import 'src/core/provider_list.dart';
import 'src/routing/route.dart';
import 'src/routing/route_name.dart';

class MyHttpOverrides extends HttpOverrides {
//? This method for handshacking error solve
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providersList,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeData(context),
          initialRoute: RouteName.splash,
          onGenerateRoute: Routes.generateRoute,
        );
      },
    );
  }
}

// class ImageScreen extends StatefulWidget {
//   const ImageScreen({super.key});

//   @override
//   State<ImageScreen> createState() => _ImageScreenState();
// }

// class _ImageScreenState extends State<ImageScreen> {
//   late Store store;
//   String? image;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     loadData();
//   }

//   loadData() async {
//     await getApplicationDocumentsDirectory().then((Directory dir) {
//       store = Store(getObjectBoxModel(), directory: '${dir.path}/musiq/db/');

//       // final SongListModel queueSongModel = SongListModel(
//       //     songId: playerSongListModel.id,
//       //     albumName: playerSongListModel.albumName,
//       //     title: playerSongListModel.title,
//       //     musicDirectorName: playerSongListModel.musicDirectorName,
//       //     imageUrl: playerSongListModel.imageUrl,
//       //     songUrl:
//       //         "https://api-musiq.applogiq.org/api/v1/audio?song_id=${playerSongListModel.id.toString()}");
//       final box = store.box<ProfileImage>();

//       var res = box.getAll();
//       print("res.length");
//       print(res.length);

//       final myObject = box.getAll();
//       for (var element in res) {
//         print(element.registerId);
//         print(element.profileImageString);
//         if (element.registerId == 2.toString()) {
//           print(element.profileImageString);
//           image = element.profileImageString;
//           setState(() {});
//         }
//       }
//       // queueIdList.clear();
//       // for (var e in res) {
//       //   queueIdList.add(e.songId);
//       // }
//       // if (queueIdList.contains(playerSongListModel.id)) {
//       //   normalToastMessage("Song already in queue ");
//       // } else {
//       //   box.put(queueSongModel);
//       //   normalToastMessage("Song added to queue ");
//       // }

//       store.close();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(
//       child: image == null
//           ? const CircularProgressIndicator()
//           : Image.memory(
//               base64Decode(image!),
//             ),
//     ));
//   }
// }
