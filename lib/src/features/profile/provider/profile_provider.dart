import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart 'as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musiq/src/constants/images.dart';
import 'package:musiq/src/features/auth/domain/models/user_model.dart';
import 'package:musiq/src/features/profile/domain/api_models/profile_update_api_model..dart';

import '../../../common_widgets/model/profile_model.dart';

class ProfileProvider extends ChangeNotifier {
  File? pickedImage;
  String getImageValue = "";
 String name = "";
  String nameError = "";
  String userName = "";
  String userNameError = "";
  ProfileApi?profileAPI;
  var profileName = "";
  var profileUserName = "";
  var profileImage = "";
  var registerid = "";
 FlutterSecureStorage secureStorage = FlutterSecureStorage();
  
 ProfileProvider(){
  getuserApi();
  notifyListeners();
 }
  void showAPIgetvalue() {
    getValue("id");
  }

  Future<void> _save(String key, String value) async {
    await secureStorage.write(key: key, value: value);
  }

  Future<String> getValue(String Key) async {
    return await secureStorage.read(key: Key) ?? "";
  }

   saveDetails() async {
     _save("id", name);
     _save("id", userName);
    
  }

  List<ProfileModel> profileContent = [
    ProfileModel(
        title: "My Profile", isArrow: true, navigateScreen: "myProfile"),
    ProfileModel(
        title: "Preferences", isArrow: true, navigateScreen: "preferences"),
    ProfileModel(
        title: "Contact us", isArrow: true, navigateScreen: "myProfile"),
  ];

  var isAboutOpen = false;

  void aboutToggle() {
    isAboutOpen = !isAboutOpen;
    notifyListeners();
  }
  nameChanged(value){
    name = value;
if(value.isEmpty){
  nameError = "Field is required";
}else{
  nameError = "";

}
    notifyListeners();
  }

    userNameChanged(value){
    userName = value;
if(value.isEmpty){
  userNameError = "Field is required";
}else{
  userNameError = "";

}
    notifyListeners();
  }

      Future pickImage(ImageSource source, BuildContext context) async {
    final Image = await ImagePicker().pickImage(
      source: source,
    );
    if (Image == null) return;
    final imagetemp = File(Image.path);
    pickedImage = imagetemp;

    Uint8List baseImage = await imagetemp.readAsBytes();
    getImageValue = base64.encode(baseImage);

    Navigator.pop(context);
    notifyListeners();
  }
  profileDeleteImage(BuildContext context) {
    pickedImage = null;
    Navigator.pop(context);
    notifyListeners();
  }
  clearError(){
    name = "";
    nameError = "";
    userName = "";
    userNameError = "";
    notifyListeners();
  }
  getuserApi()async{
    var accessToken= await secureStorage.read(
        key: "access_token",
       );
       var id= await secureStorage.read(
        key: "id",
       );
       var resid= await secureStorage.read(
        key: "register_id",
       );
       print(accessToken);
       print(id);
       print(resid);
       print("Bearer ${accessToken}");
       try{

    var response=await http.get(Uri.parse("https://api-musiq.applogiq.org/api/v1/users/${id}"),
    headers: 
    {
     'Content-type': 'application/json',
    'Accept': 'application/json',
      'Authorization': 'Bearer ${accessToken}'

    });
   
print(response.statusCode);
print(response.body);
  profileAPI = ProfileApi.fromJson(jsonDecode(response.body.toString()));
  profileName = profileAPI!.records!.fullname.toString();
  profileUserName = profileAPI!.records!.username.toString();
  profileImage = profileAPI!.records!.isImage.toString();
  registerid = profileAPI!.records!.registerId.toString();
  print(registerid);
  print(profileName);
  print(profileUserName);
  print(profileImage);
  // var d = jsonDecode(response.body.toString());
  // if()

      }catch(e){
        print(e.toString());
      }
    notifyListeners(); 
  }
  updateProfile()async{
    var accessToken= await secureStorage.read(
        key: "access_token",
       );
       var id= await secureStorage.read(
        key: "id",
       );
       print(accessToken);
       print(id.toString());


       try{
    var response = await http.put(
      Uri.parse("https://api-musiq.applogiq.org/api/v1/users/${id}"),
      headers: {
        'accept': 'application/json' ,
      "Authorization": " Bearer ${accessToken}",
       'Content-Type': 'application/json'
      },
      body: jsonEncode({
        "username": name,
        "fullname": userName,
        "image": getImageValue,
      }),
    );
    print(response.statusCode);
    print(response.body);

  
     getuserApi();


       }catch(e){
        print(e.toString());
       }
    notifyListeners();
  }
  generateProfileImageUrl() async{
     var resgisterId= await secureStorage.read(
        key: "register_id",
       );
  var url =
      "https://api-musiq.applogiq.org/public/users/${resgisterId.toString()}.png";
  return url;
}
// showImage(){
//   var data = 
// }
  

}
