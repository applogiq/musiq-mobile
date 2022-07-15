import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/helpers/constants/style.dart';
import 'package:musiq/src/logic/controller/profile_controller.dart';
import 'package:musiq/src/view/pages/profile/components/crop_image.dart';

Widget bulidsheet(context) {
  ProfileController profileController = Get.find<ProfileController>();
  return IntrinsicHeight(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        color: CustomColor.appBarColor,
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: ProfilePhotoHeader(),
          ),
          Divider(thickness: 1, color: CustomColor.textfieldBg),
          ListTile(
              onTap: () async {
                profileController.getImageFrom(source: ImageSource.camera);

                // var isPicked = await profileController.openCamera();
                // if (isPicked) {
                //   Navigator.of(context).pop();
                // }
              },
              leading: Icon(
                Icons.photo_camera,
                color: Color.fromRGBO(255, 255, 255, 0.7),
                size: 22,
              ),
              title: Text(
                "Open camera",
                style: fontWeight400(),
              )),
          ListTile(
              onTap: () async {
                // Navigator.pop(context);
                profileController.getImageFrom(source: ImageSource.gallery);
                // var isPicked = await profileController.openGallery();
                // if (isPicked) {
                //   Navigator.of(context).push(MaterialPageRoute(
                //       builder: (context) => ImageCropperScreen(
                //             imagePath: profileController.imagebytes,
                //           )));
                // }
              },
              leading: Icon(
                Icons.image,
                color: Color.fromRGBO(255, 255, 255, 0.7),
                size: 22,
              ),
              title: Text(
                "Choose from gallery",
                style: fontWeight400(),
              )),
          profileController.isImagePicked
              ? ListTile(
                  onTap: () {
                    profileController.deleteImage();
                    Navigator.of(context).pop();
                  },
                  leading: Icon(
                    Icons.delete,
                    color: Color.fromRGBO(255, 255, 255, 0.7),
                    size: 22,
                  ),
                  title: Text(
                    "Delete picture",
                    style: fontWeight400(),
                  ))
              : SizedBox()
        ],
      ),
    ),
  );
}

class ProfilePhotoHeader extends StatelessWidget {
  const ProfilePhotoHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        "Profile photo",
        style: fontWeight500(size: 16.0),
      ),
      trailing: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.close_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}
