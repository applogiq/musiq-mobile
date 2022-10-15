import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_cropper/image_cropper.dart';

import '../constants/color.dart';

class AppHelper {
  static Future<CroppedFile?> cropImage(File? imageFile) async {
    var _croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile!.path,
      maxHeight: 300,

      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              // CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              // CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: '',
            toolbarColor: CustomColor.appBarColor,
            toolbarWidgetColor: Colors.white,
            hideBottomControls: true,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
      // androidUiSettings:  AndroidUiSettings(
      //     toolbarColor: Color(0xFF2564AF),
      //     toolbarWidgetColor: Colors.white,
      //     initAspectRatio: CropAspectRatioPreset.original,
      //     lockAspectRatio: false),
    );

    return _croppedFile;
  }

  static Future<File> compress({
    required File image,
    int quality = 80,
    int percentage = 100,
  }) async {
    var path = await FlutterNativeImage.compressImage(image.absolute.path,
        quality: quality, percentage: percentage);
    return path;
  }
}
