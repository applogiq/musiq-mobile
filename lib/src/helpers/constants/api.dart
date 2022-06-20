// http://192.168.29.184:8000/users/login

class APIConstants{
 static String BASE_URL="http://192.168.29.184:3000/api/v1/";
 static String BASE_IMAGE_URL="http://192.168.29.184:3000/api/v1/public/artists/";
 static String LOGIN="users/login";
 static String REGISTER="users/register";
 static String SEND_OTP="users/email";
 static String OTP_VERIFY="users/email-otp/verify";
 static String PASSWORD_CHANGE="users/email-otp/";
 static String ARTIST_LIST="artist/?skip=0&limit=100";
//  http://192.168.29.184:3000/api/v1/artist/?skip=0&limit=100
// http://{IPAddr}:{port}/public/artists/{artist_id}.png

//  users/register users/email-otp/verify users/email-otp/
}