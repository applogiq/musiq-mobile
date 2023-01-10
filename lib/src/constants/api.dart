// http://192.168.29.184:8000/users/login

import '../config/api_config.dart';

class APIConstants {
  static String baseUrl = hostConfig["api_url"];

  static String versionUrl = "api/v1/";

  static String kLoginEndPoint = "$baseUrl${versionUrl}users/login";
  static String kRegisterEndPoint = "$baseUrl${versionUrl}users/register";
  static String kEmailVerficationEndPoint = "$baseUrl${versionUrl}users/email";
  static String kOTPVerficationEndPoint =
      "$baseUrl${versionUrl}users/email/otp-verify";
  static String kPasswordChangeEndPoint =
      "$baseUrl${versionUrl}users/email/forget-password";
  // users/email/forget-password
  static String kUpdateProfileEndPoint = "$baseUrl${versionUrl}users/";
  static String kRecentPlayedList = "$baseUrl${versionUrl}recent-list/";
  static String kArtistFollowing = "$baseUrl${versionUrl}users/follow";
  static String kTrendingHits = "$baseUrl${versionUrl}trending-hits";
  static String kAuraList = "$baseUrl${versionUrl}aura/";
  static String kArtistList = "$baseUrl${versionUrl}artist/";
  static String kAlbumList = "$baseUrl${versionUrl}albums/";
  static String kFavouriteList = "$baseUrl${versionUrl}favourite/";
  static String kPlayList = "$baseUrl${versionUrl}playlist/user/";
  static String kCreatePlayList = "$baseUrl${versionUrl}playlist/";

  getRecentlyPlayedUrl(String userId, int limit) {
    var url = "$kRecentPlayedList$userId?limit=${limit.toString()}";
    return url;
  }

  getTrendingHitsUrl({required int limit}) {
    var url = "$kTrendingHits?limit=${limit.toString()}";
    return url;
  }
  // https://api-musiq.applogiq.org/
//   String MAIN_URL = "https://api-musiq.applogiq.org/";
//   static String BASE_URL = "https://api-musiq.applogiq.org/api/v1/";

//   static String SONG_BASE_URL = "https://api-musiq.applogiq.org/";
//   static String BASE_IMAGE_URL =
//       "https://api-musiq.applogiq.org/api/v1/public/artists/";
//   // 192.168.29.101
//   static String kREGISTER = "users/register";
//   static String FAV = "favourite/";
//   static String SEND_OTP = "users/email";
//   static String OTP_VERIFY = "users/email/otp-verify";
//   static String PASSWORD_CHANGE = "users/email/forget-password";
//   static String ARTIST_LIST = "artist/?skip=0&limit=100";
//   static String ARTIST_FOLLOWING = "users/follow";
//   static String ARTIST_SONG = "songs?";
//   static String AURA = "public/aura/";
//   static String RECENT_PLAYED =
//       "http://192.168.29.101:3000/api/v1/recent-list/202201?limit=100";
//   static String PLAYLIST = "playlist/user/";
//   static String SPECIFIC_PLAYLIST = "playlist-song/list/";
//   static String CREATE_PLAYLIST = "playlist/";
//   static String PLAYLIST_SONG = "playlist-song/";
//   static String TRENDING_HITS = "trending-hits";
//   static String NEW_RELEASE = "new_release";
//   static String RECENT_LIST = "recent-list/";
//   static String USER = "users/";
//   static String FAVOURITE = "favourite/";

//   static String UPDATE_PROFILE = "https://api-musiq.applogiq.org/api/v1/users/";

//   // https://api-musiq.applogiq.org/api/v1/users/53

// // https://api-musiq.applogiq.org/api/v1/favourite/

//   // https://api-musiq.applogiq.org/api/v1/users/image/1

// // http://192.168.29.185:3000/api/v1/users/12

// //http://192.168.29.185:3000/api/v1/playlist-song/
//   getDeleteImageUrl({required String userId}) {
//     var url = "${BASE_URL}users/image/$userId";
//     return url;
//   }
// // https://api-musiq.applogiq.org/api/v1/playlist/9

//   getRenamePlaylistUrl({
//     required int playListId,
//   }) {
//     var url = CREATE_PLAYLIST + playListId.toString();
//     return url;
//   }

//   getDeletePlaylistUrl({required int playListId}) {
//     var url = BASE_URL + CREATE_PLAYLIST + playListId.toString();
//     print(url);
//     return url;
//   }

//   getNewReleaseUrl({int limit = 100}) {
//     var url = "$NEW_RELEASE?limit=${limit.toString()}";
//     return url;
//   }

//   getSpecificAlbumUrl(int id, int limit) {
//     var url = "songs?album_id=$id&skip=0&limit=${limit.toString()}";
//     return url;
//   }

//   getSpecificAuraUrl(int id, int limit) {
//     var url = "aura-song/list/$id?limit=${limit.toString()}";
//     return url;
//   }

//   getAuraUrl({int limit = 100}) {
//     var url = "aura/?limit=${limit.toString()}";
//     return url;
//   }

//   getRecentlyPlayedUrl(String? userId, int limit) {
//     var url = "recent-list/$userId?limit=${limit.toString()}";
//     return url;
//   }

//   getAlbumsUrl(int skipLength, int limit) {
//     var url = "albums/?skip=${skipLength.toString()}&limit=${limit.toString()}";
//     return url;
//   }

  getArtistUrl(int skipLength, int limit) {
    var url = "artist/?skip=${skipLength.toString()}&limit=${limit.toString()}";
    return url;
  }

//   getSpecificArtistUrl(int id, int skipLength, int limit) {
//     var url = "songs?artist_id=$id&skip=$skipLength&limit=$limit";
//     return url;
//   }

//   getTrendingHitsUrl({required int limit}) {
//     var url = "$TRENDING_HITS?limit=${limit.toString()}";
//     return url;
//   }

//  http://192.168.29.184:3000/api/v1/albums/?skip=0&limit=100

}
