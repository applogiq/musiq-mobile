class ViewAllBanner{
 final String bannerId;
 final String bannerImageUrl;
 final String bannerTitle;

  ViewAllBanner( {required this.bannerId, required this.bannerImageUrl,required this.bannerTitle});
}
class ViewAllSongList{
  final String songId;
  final String albumName;
  final String songImageUrl;
  final String songName;
  final String songMusicDirector;

  ViewAllSongList(this.songId, this.songImageUrl, this.songName, this.songMusicDirector, this.albumName);

}