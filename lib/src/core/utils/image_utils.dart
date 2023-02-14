import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:musiq/main.dart';
import 'package:musiq/src/core/local/model/user_model.dart';
import 'package:musiq/src/core/utils/url_generate.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

loadImage(String userId) async {
  print("profile");
  print(Uri.parse(generateProfileImageUrl(userId)));
  var response = await http.get(Uri.parse(generateProfileImageUrl(userId)));
  Directory documentDirectory = await getApplicationDocumentsDirectory();
  print(documentDirectory.absolute.toString());
  File file = File(join(documentDirectory.path, 'profile.png'));
  file.writeAsBytesSync(response.bodyBytes);
  print(file.path);
  objectbox.saveImage(ProfileImage(
      isImage: true, registerId: userId, profileImageString: file.path));
}

String getImage() {
  List<ProfileImage> r = objectbox.getImage();
  if (r.isNotEmpty) {
    ProfileImage res = r.first;
    print(res.id);
    print(res.isImage);
    print(res.profileImageString);
    print(res.registerId);
    return res.profileImageString;
  }
  return "";
}
