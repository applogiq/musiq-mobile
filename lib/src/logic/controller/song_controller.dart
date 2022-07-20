import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musiq/src/logic/services/api_route.dart';
import 'package:musiq/src/model/api_model/favourite_model.dart';
import 'package:musiq/src/model/ui_model/play_screen_model.dart';

class SongController extends GetxController {
  APIRoute apiRoute=APIRoute();
  var selectedIndex = 0.obs;
  var nextIndex = 0.obs;
  var isShuffle = false.obs;
  var isLyricsHide=false.obs;
  var isFav = false.obs;
  late Favourite favourite;
  var isRepeated = false.obs;
  var isBottomSheetView = false.obs;
  late AudioPlayer player;
  var isPlay = false.obs;
  var loopState = 0.obs;
  var totalDurationValue = 0.obs;
  var progressDurationValue = 0.obs;
  var bufferDurationValue = 0.obs;
  List favId=[];
  List<PlayScreenModel> songList = [];
  loadSong(List<PlayScreenModel> songPlayList, int index) async {
    
    songList = songPlayList;
    player = AudioPlayer();
     favourite = await apiRoute.getFavourites();

    for(int i=0;i<favourite.records.length;i++){
      favId.add(favourite.records[i].id);
    }
    // if(player.playing){
    //   player.stop();
    // }
//    if(isPlaying==player.playerState.playing){
// print("ALREADY PLAYING");
//    }
//    else{
    await player.setAudioSource(
      ConcatenatingAudioSource(
        useLazyPreparation: true,
        children: List.generate(
            songPlayList.length,
            (index) => AudioSource.uri(Uri.parse(
                "https://api-musiq.applogiq.org/api/v1/audio?song_id=${songPlayList[index].id}"))),
      ),
      initialIndex: index,
      initialPosition: Duration.zero,
    );
    selectedIndex.value = index;
update();
    //  }
  }

  load(List songPlayList, int index) async {
    player = AudioPlayer();

//    if(isPlaying==player.playerState.playing){
// print("ALREADY PLAYING");
//    }
//    else{
    await player.setAudioSource(
      ConcatenatingAudioSource(
        useLazyPreparation: true,
        children: List.generate(
            songPlayList.length,
            (index) => AudioSource.uri(Uri.parse(
                "http://192.168.29.184:3000/api/v1/audio?song_id=${songPlayList[index]}"))),
      ),
      initialIndex: index,
      initialPosition: Duration.zero,
    );
    selectedIndex.value = index;
update();
    //  }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    player.dispose();
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
  }

  progressDuration() {}
  shuffleSong() async {
    if (isShuffle.value == false) {
      await player.setShuffleModeEnabled(true);
    } else {
      await player.setShuffleModeEnabled(false);
    }
    isShuffle.toggle();
  }

  playNext() {
    var index = player.nextIndex;
    if (player.hasNext) {
      player.seekToNext();
      selectedIndex.value = index!;
      nextIndex.value = player.nextIndex!;
      
    update();
    }
  }

  playPrev() {
    var index = player.previousIndex;
    if (player.hasPrevious) {
      player.seekToPrevious();
      selectedIndex.value = index!;
      nextIndex.value = player.nextIndex!;
    }
    update();
  }

  playOrPause() {
    var isPlaying = player.playing;
    print(isPlaying);
    if (isPlaying) {
      player.stop();
    }

    if (isPlay.value) {
      pause();
      print("1");
    } else {
      print("2");

      play();
    }
  }

  loopSong() async {
    if (loopState.value == 0) {
      loopState.value = 1;
      await player.setLoopMode(LoopMode.all);
      isRepeated.value = true;
    } else if (loopState.value == 1) {
      loopState.value = 2;
      await player.setLoopMode(LoopMode.one);
      isRepeated.value = true;
    } else {
      loopState.value = 0;
      isRepeated.value = false;
      await player.setLoopMode(LoopMode.off);
    }
  }

  
  addToPlaylist() {}
  play() {
    if(player.playing){
      player.stop();
    }
    putRecentSongs(
        songList[int.parse(player.currentIndex.toString())].id.toString());
    isPlay.toggle();

    player.play();
    player.positionStream.listen((event) {
      progressDurationValue.value = event.inMilliseconds;
      if (progressDurationValue.value >= totalDurationValue.value) {
        playNext();
      }
    });
    player.bufferedPositionStream.listen((event) {
      bufferDurationValue.value = event.inMilliseconds;
    });
    player.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        print("Completed");
      }
    });
    player.durationStream.listen((event) {
      totalDurationValue.value = event!.inMilliseconds;
    });

    player.setLoopMode(LoopMode.all);
  }

  pause() {
    isPlay.toggle();

    player.pause();
  }

  seekDuration(value) {
    player.seek(value);
  }

  putRecentSongs(String id) async {
    APIRoute apiRoute = APIRoute();
    await apiRoute.putRecentSongs(id);
  }

  void checkFav() async {
      APIRoute apiRoute = APIRoute();
    Map params = {"song_id": songList[
                                          player.currentIndex ??
                                              0]
                                      .id
                                      .toString()};
                                      print(params);
    if (isFav.value == true) {
 var res=await apiRoute.deleteFavourite(params);
   print(res.statusCode);
    if(res.statusCode==200){
       favourite = await apiRoute.getFavourites();
favId.clear();
    for(int i=0;i<favourite.records.length;i++){
      favId.add(favourite.records[i].id);
    }
    }
    }
    else{
    var res=await apiRoute.addToFavourite(params);
    print(res.statusCode);
    if(res.statusCode==200){
       favourite = await apiRoute.getFavourites();
favId.clear();
    for(int i=0;i<favourite.records.length;i++){
      favId.add(favourite.records[i].id);
    }
    }
    }
    isFav.toggle();
    update();
  }
}
