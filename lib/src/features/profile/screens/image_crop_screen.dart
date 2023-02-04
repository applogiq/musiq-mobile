import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/buttons/custom_button.dart';
import '../../../common_widgets/loader.dart';
import '../../../constants/string.dart';
import '../../../core/package/crop/crop_your_image.dart';
import '../../../utils/size_config.dart';
import '../provider/profile_provider.dart';

class ImageCrop extends StatefulWidget {
  const ImageCrop({
    Key? key,
  }) : super(key: key);

  // final File imageUrl;

  @override
  State<ImageCrop> createState() => _ImageCropState();
}

class _ImageCropState extends State<ImageCrop> {
  late Uint8List image;
  bool imageLoad = true;
  bool isLoad = true;

  final _controller = CropController();

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
                    Icons.arrow_back_rounded,
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
                    onCropped: (image) async {
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
                          setState(() {
                            isLoad = true;
                          });
                          _controller.crop();
                        },
                        child: CustomButton(
                          isValid: !isLoad,
                          isLoading: provider.isCropSaveLoading,
                          label: ConstantText.save,
                          horizontalMargin: 0,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }
}
