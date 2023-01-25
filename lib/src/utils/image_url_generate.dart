import '../constants/api.dart';

generateArtistImageUrl(artistId) {
  var url =
      "${"${APIConstants.baseUrl}${APIConstants.versionUrl}public/artists/" + artistId}.png";
  return url;
}

generateAuraImageUrl(auraId) {
  var url = "${"${APIConstants.baseUrl}public/aura/$auraId"}.png";
  return url;
}
//  /${viewAllController.recentlyPlayed.records[index].name}/image/${viewAllController.recentlyPlayed.records[index].albumId.toString()}.png",

generateSongImageUrl(albumName, albumId) {
  var baseUrl = "${APIConstants.baseUrl}public/music/";
  var language = "tamil/";
  var albumNameStartWith = "${albumName[0].toUpperCase()}/";
  var image = "image/";
  var url =
      "${baseUrl + language + albumNameStartWith + albumName}/$image$albumId.png";
  return url;
}

generateProfileImageUrl(userRegisterId) {
  var url =
      "${APIConstants.baseUrl}public/users/${userRegisterId.toString()}.png";
  return url;
}
