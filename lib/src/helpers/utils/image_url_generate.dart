 import '../constants/api.dart';

generateArtistImageUrl(artistId){
  var url =APIConstants.BASE_IMAGE_URL+artistId+".png";
  return url;
 }
//  /${viewAllController.recentlyPlayed.records[index].name}/image/${viewAllController.recentlyPlayed.records[index].albumId.toString()}.png",
 
 generateSongImageUrl(albumName,albumId){
  var baseUrl="${APIConstants.SONG_BASE_URL}public/music/";
  var language="tamil/";
  var albumNameStartWith="${albumName[0].toUpperCase()}/";
  var image="image/";
  var url =baseUrl+language+albumNameStartWith+albumName+"/"+image+albumId.toString()+".png";
  return url;
 }