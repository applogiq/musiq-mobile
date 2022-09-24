import 'package:flutter/material.dart';
import 'package:musiq/src_main/constants/images.dart';

class LoaderScreen extends StatelessWidget {
  const LoaderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.black.withOpacity(.5),
      child: Center(
        child: Image.asset(
          Images.loaderImage,
          height: 70,
        ),
      ),
    );
  }
}
