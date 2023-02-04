import '../constants/api.dart';

//?Generate artist image url using artist id
generateArtistImageUrl(artistId) {
  var url =
      "${"${APIConstants.baseUrl}${APIConstants.versionUrl}public/artists/$artistId"}.png";
  return url;
}

//?Generate aura image url using artist id
generateAuraImageUrl(auraId) {
  var url = "${"${APIConstants.baseUrl}public/aura/$auraId"}.png";
  return url;
}

//?Generate song image url using album name and album id
generateSongImageUrl(albumName, albumId) {
  var baseUrl = "${APIConstants.baseUrl}public/music/";
  var language = "tamil/";
  var albumNameStartWith = "${albumName[0].toUpperCase()}/";
  var image = "image/";
  var url =
      "${baseUrl + language + albumNameStartWith + albumName}/$image$albumId.png";
  return url;
}

//?Generate user profile image url using user register id
generateProfileImageUrl(userRegisterId) {
  var url =
      "${APIConstants.baseUrl}public/users/${userRegisterId.toString()}.png";
  return url;
}

//?Generate song url using song id
generateSongUrl(int songId) {
  String url =
      "https://api-musiq.applogiq.org/api/v1/audio?song_id=${songId.toString()}";
  return url;
}
