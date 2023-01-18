import 'package:flutter/material.dart';

import '../../../constants/color.dart';
import '../../player/screen/player_screen.dart';

class FixedAppBar extends StatelessWidget {
  const FixedAppBar({
    Key? key,
    required this.titleOpacity,
    required this.title,
    required this.size,
  }) : super(key: key);

  final double titleOpacity;
  final double size;
  final String title;

  @override
  Widget build(BuildContext context) {
    return titleOpacity < 0.5
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          )
        : AnimatedOpacity(
            opacity: size > 0.3 ? titleOpacity.clamp(size, 1) : 1,
            duration: const Duration(milliseconds: 100),
            child: ColoredBox(
              color: Colors.black,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  // Text("Trending hits"), Spacer(),

                  const SizedBox(width: 10),

                  Expanded(
                    child: AnimatedOpacity(
                      opacity: size,
                      duration: const Duration(milliseconds: 100),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 0.0),
                        child: Text(title,
                            maxLines: 1,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                            )),
                      ),
                    ),
                  ),
                  // const Spacer(),
                  PlayButtonWidget(
                    bgColor: CustomColor.secondaryColor,
                    iconColor: CustomColor.playIconBg,
                  ),
                  AnimatedOpacity(
                    opacity: titleOpacity.clamp(0, 1),
                    duration: const Duration(milliseconds: 100),
                    child: const Padding(
                        padding: EdgeInsets.only(bottom: 0.0),
                        child: Icon(Icons.more_vert)),
                  ),
                ],
              ),
            ),
          );
  }
}
