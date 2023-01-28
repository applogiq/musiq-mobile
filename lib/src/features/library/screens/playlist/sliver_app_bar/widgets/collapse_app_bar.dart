import 'package:flutter/material.dart';
import 'package:musiq/src/constants/color.dart';
import 'package:musiq/src/features/home/provider/view_all_provider.dart';
import 'package:musiq/src/features/player/screen/player_screen/player_controller.dart';
import 'package:provider/provider.dart';

class CollapsedAppBar extends StatelessWidget {
  const CollapsedAppBar({
    Key? key,
    required this.titleOpacity,
    required this.size,
    required this.title,
    required this.callBack,
  }) : super(key: key);

  final double titleOpacity;
  final double size;
  final String title;
  final Function callBack;

  @override
  Widget build(BuildContext context) {
    return size < 0.6
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    // color: Colors.amber,
                    child: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          )
        : AnimatedOpacity(
            opacity: 1,
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
                  Consumer<ViewAllProvider>(builder: (context, pro, _) {
                    return InkWell(
                      onTap: () {
                        callBack();
                      },
                      child: PlayButtonWidget(
                        bgColor: CustomColor.secondaryColor,
                        iconColor: CustomColor.playIconBg,
                      ),
                    );
                  }),
                  AnimatedOpacity(
                    opacity: 1,
                    duration: const Duration(milliseconds: 100),
                    child: PopupMenuButton(
                        color: CustomColor.appBarColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                        ),
                        padding: const EdgeInsets.all(0.0),
                        itemBuilder: (ctx) => [
                              // _buildPopupMenuItem('Add to queue', 'share'),
                              // _buildPopupMenuItem(
                              //     'Add to playlist', "song_info"),
                            ]),
                  ),
                ],
              ),
            ),
          );
  }
}
