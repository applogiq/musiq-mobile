import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musiq/src/utils/url_generate.dart';

import '../../main.dart';
import '../features/player/domain/model/player_song_list_model.dart';

init() async {
  audioHandler = await AudioService.init(
    builder: () => AudioPlayerHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
      androidNotificationIcon: 'drawable/logo',
      androidShowNotificationBadge: true,
    ),
  );
}

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  final _player = AudioPlayer();
  static final _item = MediaItem(
    id: generateSongUrl(1),
    album: "Matinee",
    title: "Ayalthe Vettil",
    artist: "AR Rahman",
    duration: const Duration(milliseconds: 12445),
    artUri: Uri.parse(generateSongImageUrl("Matinee", "AL006")),
  );
  AudioPlayerHandler() {
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
    // mediaItem.add(_item);

    // _player.setAudioSource(AudioSource.uri(Uri.parse(_item.id)));
    // play();
    // load();
    // // loadQueueSong();
  }
  load() async {
    // _player.playbackEventStream.map(_transformEvent).pipe(playbackState);

    var res = objectbox.getAllQueueSong();
    var e = res.first;
    var mediaItemData = MediaItem(
      id: generateSongUrl(e.songId),
      album: e.albumName,
      title: e.title,
      artist: e.musicDirectorName,
      duration: const Duration(milliseconds: 124445),
      artUri: Uri.parse(e.imageUrl),
    );
    mediaItem.add(mediaItemData);
    _player.setAudioSource(AudioSource.uri(Uri.parse(mediaItemData.id)));
    play();
  }

  setSongToPlayer(PlayerSongListModel playerSongListModel) {
    var mediaItemData = MediaItem(
      id: generateSongUrl(playerSongListModel.id),
      album: playerSongListModel.albumName,
      title: playerSongListModel.title,
      artist: playerSongListModel.musicDirectorName,
      duration: const Duration(milliseconds: 12445),
      artUri: Uri.parse(playerSongListModel.imageUrl),
    );
    mediaItem.add(mediaItemData);
    _player.setAudioSource(AudioSource.uri(Uri.parse(mediaItemData.id)));
    play();
    // print(playerSongListModel.albumName);
  }

  // load() {
  //   _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
  //   mediaItem.add(_item);

  //   _player.setAudioSource(AudioSource.uri(Uri.parse(_item.id)));
  //   play();
  // }

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
