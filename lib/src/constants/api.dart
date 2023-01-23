// http://192.168.29.184:8000/users/login

import '../config/api_config.dart';

class APIConstants {
  static String baseUrl = hostConfig["api_url"];

  static String versionUrl = "api/v1/";

  static String kLoginEndPoint = "$baseUrl${versionUrl}users/login";
  static String kRegisterEndPoint = "$baseUrl${versionUrl}users/register";
  static String kProfileEndPoint = "$baseUrl${versionUrl}users/";
  static String kProfileImageDeleteEndPoint =
      "$baseUrl${versionUrl}users/image/";
  // users/image
  static String kEmailVerficationEndPoint = "$baseUrl${versionUrl}users/email";
  static String kOTPVerficationEndPoint =
      "$baseUrl${versionUrl}users/email/otp-verify";
  static String kPasswordChangeEndPoint =
      "$baseUrl${versionUrl}users/email/forget-password";

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
  static String kNewRelease = "$baseUrl${versionUrl}new_release";
  static String kFavourite = "$baseUrl${versionUrl}favourite/";
  static String kSongs = "$baseUrl${versionUrl}songs/";
  static String kPlaylistSong = "$baseUrl${versionUrl}playlist-song/";
  static String searchArtist = "$baseUrl${versionUrl}artist/list/search?data=";

  getRecentlyPlayedUrl(String userId, int limit) {
    var url = "$kRecentPlayedList$userId?limit=${limit.toString()}";
    return url;
  }

  getTrendingHitsUrl({required int limit}) {
    var url = "$kTrendingHits?limit=${limit.toString()}";
    return url;
  }

  static getSpecificArtistUrl(
    String id,
  ) {
    var url = "$baseUrl${versionUrl}songs?artist_id=$id&skip=0&limit=100";
    return url;
  }

  static getArtistUrl(int skipLength, int limit) {
    var url =
        "$kArtistList?skip=${skipLength.toString()}&limit=${limit.toString()}";
    return url;
  }
}
