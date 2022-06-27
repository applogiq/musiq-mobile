import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class SongController extends GetxController{
  var selectedIndex=0.obs;
  var nextIndex=0.obs;
  var isShuffle=false.obs;
  var isRepeated=false.obs;
  var isBottomSheetView=false.obs;
   late AudioPlayer player;
   var isPlay=false.obs;
   var loopState=0.obs;
   var totalDurationValue=0.obs;
   var progressDurationValue=0.obs;
   var bufferDurationValue=0.obs;
 load(List songPlayList,int index)async{
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
              
                "http://192.168.29.185:3000/api/v1/audio?song_id=${songPlayList[index]}"))),
      
  ),
  
  initialIndex: index,
  
  
  initialPosition: Duration.zero,
);
selectedIndex.value=index;


  //  }
     }
 
 @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    player.dispose();
  }
   @override
  void onInit() async{
    // TODO: implement onInit
    super.onInit();

  
  }
  
  
  
  
  progressDuration(){}
  shuffleSong()async{
    if(isShuffle.value==false){
 await player.setShuffleModeEnabled(true);
    }
    else{
await player.setShuffleModeEnabled(false);
    }
isShuffle.toggle();
  }
  playNext(){
    var index=player.nextIndex;
    if(player.hasNext){
      player.seekToNext();
      selectedIndex.value=index!;
      nextIndex.value=player.nextIndex!;;
    }
  }
  playPrev(){
      var index=player.previousIndex;
     if(player.hasPrevious){
      player.seekToPrevious();
       selectedIndex.value=index!;
        nextIndex.value=player.nextIndex!;
    }
  }
  playOrPause(){
      var isPlaying = player.playing;
   print(isPlaying);
   if(isPlaying){
    player.stop();
   }
                                    
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
      progressDurationValue.value=event.inMilliseconds;
      if(progressDurationValue.value>=totalDurationValue.value){
        playNext();
      }
    });
    player.bufferedPositionStream.listen((event) { 
      bufferDurationValue.value=event.inMilliseconds;
    });
    player.playerStateStream.listen((event) { 
    if(event.processingState == ProcessingState.completed){
      print("Completed");
    }
    });
    player.durationStream.listen((event) { 
      totalDurationValue.value=event!.inMilliseconds;
    });
    
    player.setLoopMode(LoopMode.all);
  }
  pause(){
        isPlay.toggle();


    player.pause();
  }

seekDuration(value){
  player.seek(value);
}

}