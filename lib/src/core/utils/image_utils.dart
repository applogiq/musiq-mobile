import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:musiq/src/core/constants/local_storage_constants.dart';
import 'package:musiq/src/core/utils/url_generate.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

loadImage(String userId) async {
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  var response = await http.get(Uri.parse(generateProfileImageUrl(userId)));
  Directory documentDirectory = await getApplicationDocumentsDirectory();

  int timestamp = DateTime.now().millisecondsSinceEpoch;
  File file = File(join(documentDirectory.path, '${timestamp.toString()}.png'));
  file.writeAsBytesSync(response.bodyBytes);
  await secureStorage.write(
      key: LocalStorageConstant.profileUrl, value: file.path);
  // objectbox.saveImage(ProfileImage(
  //     isImage: true, registerId: userId, profileImageString: file.path));
}
