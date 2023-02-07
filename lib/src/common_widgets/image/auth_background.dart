import 'package:flutter/material.dart';
import 'package:musiq/src/core/constants/images.dart';

class Background extends StatelessWidget {
  const Background({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImageWidget(),
        Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  stops: [
                0.1,
                0.65
              ],
                  colors: [
                Color.fromRGBO(22, 21, 28, 0),
                Color.fromRGBO(2, 0, 1, 1),
              ])),
        )
      ],
    );
  }
}

class BackgroundImageWidget extends StatelessWidget {
  const BackgroundImageWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: const AssetImage(
                Images.backgroundImage,
              ),
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.8), BlendMode.dstATop),
              fit: BoxFit.cover)),
    );
  }
}
