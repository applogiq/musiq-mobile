import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/container/empty_box.dart';
import '../../../core/constants/color.dart';
import '../../../core/constants/style.dart';
import '../provider/profile_provider.dart';

class ImagePickerSheet extends StatelessWidget {
  const ImagePickerSheet({super.key, required this.mainContext});

  final BuildContext mainContext;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
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
                  await context.read<ProfileProvider>().getImageFrom(
                      source: ImageSource.camera, context: context);
                  // await profileController.getImageFrom(
                  //     source: ImageSource.camera);

                  // // var isPicked = await profileController.openCamera();
                  // // if (isPicked) {

                  // }
                },
                leading: const Icon(
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
                  await context.read<ProfileProvider>().getImageFrom(
                      source: ImageSource.gallery, context: context);
                  // await profileController.getImageFrom(
                  //     source: ImageSource.camera);

                  // // var isPicked = await profileController.openCamera();
                  // // if (isPicked) {
                  // Navigator.of(context).pop();
                  // Navigator.pop(context);
                  // await profileController.getImageFrom(
                  //     source: ImageSource.gallery);
                  // Navigator.pop(context);
                  // var isPicked = await profileController.openGallery();
                  // if (isPicked) {
                  //   Navigator.of(context).push(MaterialPageRoute(
                  //       builder: (context) => ImageCropperScreen(
                  //             imagePath: profileController.imagebytes,
                  //           )));
                  // }
                },
                leading: const Icon(
                  Icons.image,
                  color: Color.fromRGBO(255, 255, 255, 0.7),
                  size: 22,
                ),
                title: Text(
                  "Choose from gallery",
                  style: fontWeight400(),
                )),
            (context.read<ProfileProvider>().fileImage != null ||
                    context
                            .read<ProfileProvider>()
                            .profileAPIModel
                            .records!
                            .isImage ==
                        true)
                ? ListTile(
                    onTap: () async {
                      await context
                          .read<ProfileProvider>()
                          .deleteImage(context, mainContext);
                      // Navigator.of(context).pop();
                      // Navigator.of(context).pop();

                      // Navigator.of(mainContext).pop();

                      // if (res.statusCode == 200) {
                      //   Navigation.navigateReplaceToScreen(
                      //       mainContext, RouteName.profile);
                      // } else {}

                      // profileController.deleteImage(context);
                      // Navigator.of(context).pop();
                    },
                    leading: const Icon(
                      Icons.delete,
                      color: Color.fromRGBO(255, 255, 255, 0.7),
                      size: 22,
                    ),
                    title: Text(
                      "Delete picture",
                      style: fontWeight400(),
                    ))
                : const EmptyBox()
            // profileController.isImagePicked || profileController.isImage.value
            // ? ListTile(
            //     onTap: () async {
            //       profileController.deleteImage(context);
            //       // Navigator.of(context).pop();
            //     },
            //     leading: Icon(
            //       Icons.delete,
            //       color: Color.fromRGBO(255, 255, 255, 0.7),
            //       size: 22,
            //     ),
            //     title: Text(
            //       "Delete picture",
            //       style: fontWeight400(),
            //     ))
            // : SizedBox()
          ],
        ),
      ),
    );
  }
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
        icon: const Icon(
          Icons.close_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}
