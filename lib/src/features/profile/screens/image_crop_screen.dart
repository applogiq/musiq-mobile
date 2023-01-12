import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:musiq/src/common_widgets/loader.dart';
import 'package:musiq/src/features/profile/provider/profile_provider.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/buttons/custom_button.dart';
import '../../../constants/string.dart';
import '../../../core/package/crop/src/controller.dart';
import '../../../core/package/crop/src/crop.dart';
import '../../../utils/size_config.dart';

class ImageCrop extends StatefulWidget {
  const ImageCrop({
    Key? key,
  }) : super(key: key);
  // final File imageUrl;

  @override
  State<ImageCrop> createState() => _ImageCropState();
}

class _ImageCropState extends State<ImageCrop> {
  final _controller = CropController();

  bool isLoad = true;
  late Uint8List image;
  bool imageLoad = true;

  @override
  void initState() {
    super.initState();
    convertImageToByte();
  }

  convertImageToByte() async {
    Uint8List imagebytes =
        await context.read<ProfileProvider>().fileImage!.readAsBytes();
    image = imagebytes;

    setState(() {
      image;
      isLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final imageProvider = Provider.of<ImagePickerProvider>(context);
    return isLoad
        ? const LoaderScreen()
        : Scaffold(
            backgroundColor: const Color.fromRGBO(2, 10, 16, 1),
            appBar: AppBar(
              leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                  )),
              backgroundColor: const Color.fromRGBO(2, 10, 16, 1),
            ),
            body: Column(
              children: [
                const Spacer(),
                SizedBox(
                  height: getProportionateScreenHeight(375),
                  child: Crop(
                    image: image,
                    initialAreaBuilder: (rect) => Rect.fromLTRB(rect.left + 72,
                        rect.top + 50, rect.right - 72, rect.bottom - 60),
                    cornerDotBuilder: (size, edgeAlignment) =>
                        const DotControl(),
                    onStatusChanged: (cr) {
                      if (cr == CropStatus.ready) {
                        if (mounted) {
                          setState(() {
                            imageLoad = false;
                          });
                        }
                      }
                    },
                    aspectRatio: 1 / 2,
                    baseColor: Colors.transparent,
                    maskColor: const Color.fromRGBO(2, 10, 16, 0.5),
                    controller: _controller,
                    onCropped: (image) {
                      context.read<ProfileProvider>().saveImage(image, context);
                    },
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Consumer<ProfileProvider>(
                      builder: (context, provider, _) {
                    return InkWell(
                      onTap: () async {
                        _controller.crop();

                        // Navigator.pop(context);
                      },
                      child: CustomButton(
                        isValid: provider.isCropSave,
                        isLoading: provider.isCropSaveLoading,
                        label: ConstantText.save,
                        horizontalMargin: 0,
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
  }
}
