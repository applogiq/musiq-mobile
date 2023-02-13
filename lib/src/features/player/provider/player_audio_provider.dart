import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musiq/src/features/player/provider/player_provider.dart';
import 'package:rxdart/rxdart.dart';

// enum PlayerState { stopped, playing, paused }
abstract class AudioPlayerHandlerInterface implements AudioHandler {
  Stream<QueueState> get queueState;
  // Future<void> moveQueueItem(int currentIndex, int newIndex);
  // ValueStream<double> get volume;
  // Future<void> setVolume(double volume);
  // ValueStream<double> get speed;
}

class AudioPlayerHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler
    implements AudioPlayerHandlerInterface {
  final _player = AudioPlayer();
  FlutterSecureStorage storage = const FlutterSecureStorage();
  final _playlist = ConcatenatingAudioSource(children: []);
  AudioPlayer get player => _player;
  AudioPlayerHandler() {
    _loadEmptyPlaylist();
    _notifyAudioHandlerAboutPlaybackEvents();
    _listenForDurationChanges();
    _listenForCurrentSongIndexChanges();
    _listenForSequenceStateChanges();
    _listenForShuffleChanges();
    _loadProgress();
  }
  Future<void> _loadEmptyPlaylist() async {
    try {
      await _player.setAudioSource(_playlist);
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
    }
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.playbackEventStream.listen((PlaybackEvent event) {
      final playing = _player.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        repeatMode: const {
          LoopMode.off: AudioServiceRepeatMode.none,
          LoopMode.one: AudioServiceRepeatMode.one,
          LoopMode.all: AudioServiceRepeatMode.all,
        }[_player.loopMode]!,
        shuffleMode: (_player.shuffleModeEnabled)
            ? AudioServiceShuffleMode.all
            : AudioServiceShuffleMode.none,
        playing: playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: event.currentIndex!,
      ));
    });
  }

  void _loadProgress() {
    _player.positionStream.listen((event) {
      if (event.toString().trim() != " 0:00:00.000000".toString().trim()) {
        storage.write(key: "lastPosition", value: event.toString());
      }
    });
  }

  void _listenForDurationChanges() {
    _player.durationStream.listen((duration) {
      var index = _player.currentIndex;
      final List<MediaItem?> newQueue = queue.value;
      if (index == null || newQueue.isEmpty) return;
      if (_player.shuffleModeEnabled) {
        index = _player.shuffleIndices![index];
      }
      final oldMediaItem = newQueue[index]!;
      final MediaItem newMediaItem = oldMediaItem.copyWith(
          duration: duration ?? const Duration(minutes: 1));
      newQueue[index] = newMediaItem;
      queue.add(newQueue as List<MediaItem>);
      mediaItem.add(newMediaItem);
    });
  }

  void _listenForCurrentSongIndexChanges() {
    _player.currentIndexStream.listen((index) {
      final playlist = queue.value;
      if (index == null || playlist.isEmpty) return;
      if (_player.shuffleModeEnabled) {
        index = _player.shuffleIndices![index];
        storage.write(key: "currentIndex", value: index.toString());
      }
      storage.write(key: "currentIndex", value: index.toString());

      try {
        mediaItem.add(playlist[index]);
      } catch (e) {
        debugPrint("####################");
        debugPrint(e.toString());
      }
    });
  }

  void _listenForSequenceStateChanges() {
    _player.sequenceStateStream.listen((SequenceState? sequenceState) {
      final sequence = sequenceState?.effectiveSequence;
      if (sequence == null || sequence.isEmpty) return;
      final items = sequence.map((source) => source.tag as MediaItem);
      queue.add(items.toList());
    });
  }

  void remove() async {
    final lastIndex = queue.value.length - 1;
    if (lastIndex < 0) return;
    removeQueueItemAt(lastIndex);
  }

  @override
  Future<void> updateQueue(List<MediaItem> newQueue) async {
    debugPrint(newQueue.toString());
    debugPrint(_playlist.length.toString());
    while (_playlist.length != 0) {
      for (int i = 0; i < _playlist.length; i++) {
        remove();
      }
    }
    debugPrint(_playlist.length.toString());

    // await _player.setAudioSource(ConcatenatingAudioSource(children: []));
    // // await addQueueItems(mediaItems);
    // // final audioSource = mediaItems.map(_createAudioSource);
    // // _playlist.addAll(audioSource.toList());
    // // print(_playlist.length);

    // // notify system
    // final newQueue = queue.value..addAll(mediaItems);
    // queue.add(newQueue);
    // print(queue.value.length);
  }

  @override
  Future<void> insertQueueItem(int index, MediaItem mediaItem) async {
    final audioSource = _createAudioSource(mediaItem);
    try {
      _playlist.insert(index + 1, audioSource);
    } catch (e) {
      _playlist.add(audioSource);
    }
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    // manage Just Audio
    final audioSource = mediaItems.map(_createAudioSource);
    _playlist.addAll(audioSource.toList());

    // notify system
    final newQueue = queue.value..addAll(mediaItems);
    queue.add(newQueue);
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    // manage Just Audio
    final audioSource = _createAudioSource(mediaItem);
    _playlist.add(audioSource);

    // notify system
    final newQueue = queue.value..add(mediaItem);
    queue.add(newQueue);
  }

  UriAudioSource _createAudioSource(MediaItem mediaItem) {
    return AudioSource.uri(
      Uri.parse(mediaItem.id),
      tag: mediaItem,
    );
  }

  @override
  Future<void> removeQueueItemAt(int index) async {
    // manage Just Audio
    _playlist.removeAt(index);

    // notify system
    final newQueue = queue.value..removeAt(index);
    queue.add(newQueue);
  }

  @override
  Future<void> removeQueueItem(MediaItem mediaItem) async {
    final index = queue.value.indexOf(mediaItem);
    await _playlist.removeAt(index);
  }

  @override
  Future<void> play() async {
    _player.setPreferredPeakBitRate(360);
    _player.play();
  }

  @override
  Future<void> pause() async {
    print("dfdffdg");
    storage.write(key: "currentIndex", value: _player.currentIndex.toString());
    storage.write(
        key: "lastPosition", value: _player.position.inSeconds.toString());
    _player.pause();
    // print(_player.currentIndex);
    print(await storage.read(key: "lastPosition"));
  }

  @override
  Future<void> seek(Duration position) async {
    print(position);
    _player.seek(position);
  }

  @override
  Stream<QueueState> get queueState =>
      Rx.combineLatest3<List<MediaItem>, PlaybackState, List<int>, QueueState>(
          queue,
          playbackState,
          _player.shuffleIndicesStream.whereType<List<int>>(),
          (queue, playbackState, shuffleIndices) => QueueState(
                queue,
                playbackState.queueIndex,
                playbackState.shuffleMode == AudioServiceShuffleMode.all
                    ? shuffleIndices
                    : null,
                playbackState.repeatMode,
              )).where((state) =>
          state.shuffleIndices == null ||
          state.queue.length == state.shuffleIndices!.length);

  @override
  Future<void> skipToQueueItem(int index) async {
    print("innnn");
    print(index);
    print(queue.value.length);
    if (index < 0 || index > queue.value.length) return;
    if (_player.shuffleModeEnabled) {
      index = _player.shuffleIndices![index];
    }
    _player.seek(Duration.zero, index: index);
  }

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        _player.setLoopMode(LoopMode.off);
        break;
      case AudioServiceRepeatMode.one:
        _player.setLoopMode(LoopMode.one);
        break;
      case AudioServiceRepeatMode.group:
      case AudioServiceRepeatMode.all:
        _player.setLoopMode(LoopMode.all);
        break;
    }
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    final enabled = shuffleMode == AudioServiceShuffleMode.all;

    if (enabled) {
      _player.shuffle();
    }
    playbackState.add(playbackState.value.copyWith(shuffleMode: shuffleMode));
    await _player.setShuffleModeEnabled(enabled);
  }

  int? getQueueIndex(
      int? currentIndex, bool shuffleModeEnabled, List<int>? shuffleIndices) {
    final effectiveIndices = _player.effectiveIndices ?? [];
    final shuffleIndicesInv = List.filled(effectiveIndices.length, 0);
    for (var i = 0; i < effectiveIndices.length; i++) {
      shuffleIndicesInv[effectiveIndices[i]] = i;
    }
    return (shuffleModeEnabled &&
            ((currentIndex ?? 0) < shuffleIndicesInv.length))
        ? shuffleIndicesInv[currentIndex ?? 0]
        : currentIndex;
  }

  /// A stream of the current effective sequence from just_audio.
  Stream<List<IndexedAudioSource>> get _effectiveSequence => Rx.combineLatest3<
              List<IndexedAudioSource>?,
              List<int>?,
              bool,
              List<IndexedAudioSource>?>(_player.sequenceStream,
          _player.shuffleIndicesStream, _player.shuffleModeEnabledStream,
          (sequence, shuffleIndices, shuffleModeEnabled) {
        if (sequence == null) return [];
        if (!shuffleModeEnabled) return sequence;
        if (shuffleIndices == null) return null;
        if (shuffleIndices.length != sequence.length) return null;
        return shuffleIndices.map((i) => sequence[i]).toList();
      }).whereType<List<IndexedAudioSource>>();

  @override
  customAction(String name, [Map<String, dynamic>? extras]) async {
    switch (name) {
      case 'dispose':
        await _player.dispose();
        super.stop();
        break;
      case 'positionStream':
        return _player.positionStream;

      case 'currentIndex':
        return _player.currentIndexStream;
      case 'hasNext':
        return _player.hasNext;
      case 'clearPlaylist':
        _playlist.clear();
        break;
      default:
    }
  }

  @override
  Future<void> stop() async {
    await _player.pause();
    await _player.seek(Duration.zero);
    return super.stop();
  }

  Future<void> _listenForShuffleChanges() async {
    //  _player.playbackEventStream.listen(_notifyAudioHandlerAboutPlaybackEvents());
    _player.shuffleModeEnabledStream
        .listen((enabled) => _notifyAudioHandlerAboutPlaybackEvents());
    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        stop();

        _player.seek(Duration.zero, index: 0);
      }
    });
  }
}
