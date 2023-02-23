import '../config/api_config.dart';

class APIConstants {
  static String baseUrl = hostConfig["api_url"];
  static String kAlbumList = "$baseUrl${versionUrl}albums/";
  static String kAlbumSongList = "$baseUrl${versionUrl}songs?album_id=";
  static String kArtistFollowing = "$baseUrl${versionUrl}users/follow";
  static String kArtistList = "$baseUrl${versionUrl}artist/";
  static String kAuraList = "$baseUrl${versionUrl}aura/";
  static String kAuraSongList = "$baseUrl${versionUrl}aura-song/list/";
  static String kCreatePlayList = "$baseUrl${versionUrl}playlist/";
  // users/image
  static String kEmailVerficationEndPoint = "$baseUrl${versionUrl}users/email";

  static String kFavourite = "$baseUrl${versionUrl}favourite/";
  static String kFavouriteList = "$baseUrl${versionUrl}favourite/";
  static String kLoginEndPoint = "$baseUrl${versionUrl}users/login";
  static String kNewRelease = "$baseUrl${versionUrl}new_release";
  static String kOTPVerficationEndPoint =
      "$baseUrl${versionUrl}users/email/otp-verify";

  static String kPasswordChangeEndPoint =
      "$baseUrl${versionUrl}users/email/forget-password";

  static String kPlayList = "$baseUrl${versionUrl}playlist/user/";
  static String kPlaylistSong = "$baseUrl${versionUrl}playlist-song/";
  static String kPlaylistSongList = "${kPlaylistSong}list/";
  static String kProfileEndPoint = "$baseUrl${versionUrl}users/";
  static String kProfileImageDeleteEndPoint =
      "$baseUrl${versionUrl}users/image/";

  static String kRecentPlayedList = "$baseUrl${versionUrl}recent-list/";
  static String kRegisterEndPoint = "$baseUrl${versionUrl}users/register";
  static String kSearchSong = "$baseUrl${versionUrl}search?data=";
  static String kSongs = "$baseUrl${versionUrl}songs/";
  static String kTrendingHits = "$baseUrl${versionUrl}trending-hits";
  static String paymentCreateEndpoint =
      "$baseUrl${versionUrl}users-payment/create";

  static String kUpdateProfileEndPoint = "$baseUrl${versionUrl}users/";
  static String searchArtist = "$baseUrl${versionUrl}artist/list/search?data=";
  static String subscriptionListEndPoint =
      "$baseUrl${versionUrl}premium?limit=100";
  static String versionUrl = "api/v1/";

// https://api-musiq.applogiq.org/api/v1/playlist-song/40
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
    var url = "$kArtistList?skip=0&limit=${limit.toString()}";

    return url;
  }
}
