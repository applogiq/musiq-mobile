import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:musiq/main.dart';
import 'package:musiq/src/core/local/model/user_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ProfileImageScreen extends StatefulWidget {
  const ProfileImageScreen({super.key});

  @override
  State<ProfileImageScreen> createState() => _ProfileImageScreenState();
}

class _ProfileImageScreenState extends State<ProfileImageScreen> {
  String? imageUrl;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // loadImage();
    getImage();
    loadData();
  }

  loadData() async {
    if (objectbox.getImage().isNotEmpty) {
      objectbox.getImage().forEach((element) {
        print(element.profileImageString);
      });
    }
  }

  getImage() async {
    List<ProfileImage> r = objectbox.getImage();
    if (r.isNotEmpty) {
      ProfileImage res = r.first;
      print(res.id);
      print(res.isImage);
      print(res.profileImageString);
      print(res.registerId);
      imageUrl = res.profileImageString;
      setState(() {});
    }
  }

  loadImage() async {
    var response = await http.get(Uri.parse(
        "https://plus.unsplash.com/premium_photo-1675857197719-e77af35bcd8f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxMHx8fGVufDB8fHx8&auto=format&fit=crop&w=500&q=60"));
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    print(documentDirectory.absolute.toString());
    File file = File(join(documentDirectory.path, 'imagetest.png'));
    file.writeAsBytesSync(response.bodyBytes);
    print(file.path);
    objectbox.saveImage(ProfileImage(
        isImage: true, registerId: "1", profileImageString: file.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: imageUrl != null
          ? Image.file(
              File("/data/user/0/org.applogiq.musiq/app_flutter/profile.png"))
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
