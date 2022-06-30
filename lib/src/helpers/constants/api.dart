// http://192.168.29.184:8000/users/login

class APIConstants{
 static String BASE_URL="http://192.168.29.185:3000/api/v1/";
 static String SONG_BASE_URL="http://192.168.29.185:3000/";
 static String BASE_IMAGE_URL="http://192.168.29.185:3000/api/v1/public/artists/";
 static String LOGIN="users/login";
 static String REGISTER="users/register";
 static String FAV="favourite/";
 static String SEND_OTP="users/email";
 static String OTP_VERIFY="users/email/otp-verify";
 static String PASSWORD_CHANGE="users/email/forget-password";
 static String ARTIST_LIST="artist/?skip=0&limit=100";
 static String ARTIST_FOLLOWING="users/follow";
 static String ARTIST_SONG="songs?";
 static String AURA="public/aura/";
 static String RECENT_PLAYED="http://192.168.29.185:3000/api/v1/recent-list/202201?limit=100";
 static String PLAYLIST="playlist/user/";

// http://192.168.29.185:3000/api/v1/playlist/user/2

getSpecificAlbumUrl(int id,int limit){

  var url="songs?album_id=${id}&skip=0&limit=${limit.toString()}";
  return url;
 }


getSpecificAuraUrl(int id,int limit){

  var url="aura-song/list/${id}?limit=${limit.toString()}";
  return url;
 }
getAuraUrl({int limit=100}){
  var url="aura/?limit=${limit.toString()}";
  return url;
 
}

 getRecentlyPlayedUrl(String? userId,int limit){
  var url="recent-list/${userId}?limit=${limit.toString()}";
  return url;
 }
 getAlbumsUrl(int skipLength,int limit){
  var url="albums/?skip=${skipLength.toString()}&limit=${limit.toString()}";
  return url;
 }
  getArtistUrl(int skipLength,int limit){
  var url="artist/?skip=${skipLength.toString()}&limit=${limit.toString()}";
  return url;
 }
getSpecificArtistUrl(int id,int skipLength,int limit){

  var url="songs?artist_id=${id}&skip=${skipLength}&limit=${limit}";
  return url;
 }

//  http://192.168.29.184:3000/api/v1/albums/?skip=0&limit=100



}