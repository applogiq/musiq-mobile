import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musiq/src/local/model/queue_model.dart';
import 'package:musiq/src/utils/image_url_generate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'objectbox.g.dart';
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

late AudioHandler _audioHandler;
Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  // await setupServiceLocator();
  // sl<MyAudioHandler>().initAudioService();
  _audioHandler = await AudioService.init(
    builder: () => AudioPlayerHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
      // androidStopForegroundOnPause: true,
      // androidNotificationIcon: 'drawable/logo',
      // androidShowNotificationBadge: true,
    ),
  );
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

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  final _player = AudioPlayer();
  static final _item = MediaItem(
    id: 'https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3',
    album: "Matinee",
    title: "Ayalthe Vettil",
    artist: "AR Rahman",
    duration: const Duration(milliseconds: 12445),
    artUri: Uri.parse(generateSongImageUrl("Matinee", "AL006")),
  );
  late ConcatenatingAudioSource playlist;
  late Store store;
  AudioPlayerHandler() {
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
    mediaItem.add(_item);

    _player.setAudioSource(AudioSource.uri(Uri.parse(_item.id)));
    play();
    // loadQueueSong();
  }
  loadQueueSong() async {
    await getApplicationDocumentsDirectory().then((Directory dir) async {
      store = Store(getObjectBoxModel(), directory: '${dir.path}/musiq/db/23/');
      final box = store.box<SongListModel>();

      var res = box.getAll();

      if (res.isNotEmpty) {
        List<MediaItem> playerSongList = [];

        var temp = res.first;

        var item = MediaItem(
          id: 'https://api-musiq.applogiq.org/api/v1/audio?song_id=1',
          album: temp.albumName,
          title: temp.title,
          artist: temp.musicDirectorName,
          duration: const Duration(milliseconds: 5739820),
          artUri: Uri.parse(temp.imageUrl),
        );
        mediaItem.add(item);
        _player.setAudioSource(AudioSource.uri(Uri.parse(
            'https://api-musiq.applogiq.org/api/v1/audio?song_id=1')));
        print("mediaItem");
        print(mediaItem);

        store.close();
        play();
      }
    });
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() => _player.stop();

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
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
//       store = Store(getObjectBoxModel(), directory: '\$\{dir\.path\}/musiq/db/1');

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
