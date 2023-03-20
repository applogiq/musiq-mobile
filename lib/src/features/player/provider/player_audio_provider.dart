import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/constants/color.dart';
import '../../library/domain/models/playlist_model.dart';
import '../domain/model/song_info_model.dart';
import '../domain/repo/player_repo.dart';

class PlayerAudioProvider extends ChangeNotifier {
  FlutterSecureStorage storage = const FlutterSecureStorage();
  bool isPlay = false;
  bool isPlaying = false;
  bool isShuffle = false;
  bool issongInfoDetailsLoad = true;
  int loopStatus = 0;
  int index = 2;
  bool inQueue = false;
  bool isUpNextShow = false;
  bool isRecentlyAPICalled = false;
  Color miniPlayerBackground = CustomColor.miniPlayerBackgroundColors[0];
  void toggleUpNext() {
    isUpNextShow = !isUpNextShow;
    notifyListeners();
  }

  List<int> favouritesList = [];
  List<int> queueIdList = [];
  List songPosition = [];
  ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: []);

  AudioPlayer player = AudioPlayer();

  var selectedIndex = 0;
  var progressDurationValue = 0;
  var totalDurationValue = 0;
  var bufferDurationValue = 0;
  SongInfoModel? songInfoModel;
  PlayerRepo playerRepo = PlayerRepo();
  bool isPlayListLoad = true;
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  PlayListModel playListModel = PlayListModel(
      success: false, message: "No records", records: [], totalRecords: 0);
  AudioHandler? _audioHandler;
  List<MediaItem> globalQueue = [];
  int? globalIndex;
  Stream<Duration>? positionStream = const Stream.empty();
  Stream<int>? currentIndex = const Stream.empty();

  AudioHandler? get audioHandler => _audioHandler;

  iscurrentIndex() {
    return player.currentIndex.toString();
  }
// Load queue from local db
  // loadQueueSong() async {
  //   if (!inQueue) {
  //     // await getFavourites();
  //     var index = await secureStorage.read(key: "currentIndex");
  //     var songPosition = await secureStorage.read(key: "lastPosition");
  //     isPlaying = false;
  //     notifyListeners();
  //     print(songPosition);
  //     List songPositionList = [];
  //     List songPositionSeconds = [];
  //     if (songPosition != null) {
  //       songPositionList = songPosition.toString().split(":");
  //       print(songPositionSeconds);
  //       if (songPositionSeconds.isNotEmpty) {
  //         songPositionSeconds = songPositionList[2].toString().split(".");
  //       }
  //     }
  //     var res = objectbox.getAllQueueSong();
  //     if (res.isNotEmpty) {
  //       queueIdList.clear();
  //       List<PlayerSongListModel> playerSongList = [];
  //       for (var e in res) {
  //         playerSongList.add(PlayerSongListModel(
  //             id: e.songId,
  //             albumName: e.albumName,
  //             title: e.title,
  //             imageUrl: e.imageUrl,
  //             musicDirectorName: e.musicDirectorName,
  //             duration: e.duration,
  //             premium: '',
  //             isImage: e.isImage));
  //         final item = MediaItem(
  //             id: generateSongUrl(e.songId),
  //             album: e.albumName,
  //             title: e.title,
  //             artist: e.musicDirectorName,
  //             duration: Duration(milliseconds: totalDuration(e.duration)),
  //             artUri: Uri.parse(e.imageUrl),
  //             extras: {"song_id": e.songId, "isImage": e.isImage});
  //         playlist.add(
  //           AudioSource.uri(
  //               Uri.parse(
  //                 generateSongUrl(e.songId),
  //               ),
  //               tag: item),
  //         );
  //       }
  //       player.setAudioSource(playlist);
  //       try {
  //         print("TRY init");
  //         print(songPositionList);
  //         print(songPositionSeconds);
  //         if (songPositionSeconds.isNotEmpty && songPositionList.isNotEmpty) {
  //           player.seek(
  //               Duration(
  //                   hours: int.parse(songPositionList[0]),
  //                   minutes: int.parse(songPositionList[1]),
  //                   seconds: int.parse(songPositionSeconds[0])),
  //               index: int.parse(index!));
  //         }
  //       } catch (e) {
  //         debugPrint(e.toString());
  //       }

  //       isPlaying = true;
  //       notifyListeners();
  //     } else {
  //       isPlaying = false;
  //     }
  //     inQueue = true;
  //     notifyListeners();
  //   }
  // }
}
