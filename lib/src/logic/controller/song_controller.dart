import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class SongController extends GetxController{
  var isShuffle=false.obs;
  var isRepeated=false.obs;
   late AudioPlayer player;
   var isPlay=false.obs;
   var loopState=0.obs;
   var duration=0.obs;
   @override
  void onInit() async{
    // TODO: implement onInit
    super.onInit();
    player = AudioPlayer();
    await player.setAudioSource(
  ConcatenatingAudioSource(
    // Start loading next item just before reaching it.
    useLazyPreparation: true, // default
    // Customise the shuffle algorithm.
    shuffleOrder: DefaultShuffleOrder(), // default
    // Specify the items in the playlist.
    children: [
      AudioSource.uri(Uri.parse("http://192.168.29.184:3000/api/v1/audio?song_id=1")),
      AudioSource.uri(Uri.parse("http://192.168.29.184:3000/api/v1/audio?song_id=2")),
      AudioSource.uri(Uri.parse("http://192.168.29.184:3000/api/v1/audio?song_id=3")),
    ],
  ),
  // Playback will be prepared to start from track1.mp3
  initialIndex: 0, // default
  // Playback will be prepared to start from position zero.
  initialPosition: Duration.zero, // default
);
  }
  progressDuration(){}
  shuffleSong(){

  }
  playNext(){
    if(player.hasNext){
      player.seekToNext();
    }
  }
  playPrev(){
     if(player.hasPrevious){
      player.seekToPrevious();
    }
  }
  playOrPause(){
    
                                    
                                     if(isPlay.value){
                                     pause();
                                     print("1");
                                     }
                                     else{
                                     print("2");

                                     play();

                                      }
  }
  loopSong()async{
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
  favourite(){}
  addToPlaylist(){}
  play(){
    isPlay.toggle();
    
    player.play();
    player.positionStream.listen((event) { 
      duration.value=event.inMilliseconds;
    });
    
    player.setLoopMode(LoopMode.all);
  }
  pause(){
        isPlay.toggle();


    player.pause();
  }



}