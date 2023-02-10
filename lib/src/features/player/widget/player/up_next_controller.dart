import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/container/empty_box.dart';
import '../../../../core/constants/constant.dart';
import '../../provider/player_provider.dart';
import '../../screen/player_screen/player_screen.dart';
import '../../screen/player_screen/up_next.dart';

class UpNextController extends StatelessWidget {
  const UpNextController({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(
      builder: (context, pro, _) {
        return pro.isUpNextShow
            ? const SizedBox.shrink()
            : Container(
                decoration: topLeftRightDecoration(),
                child: ListTile(
                  onTap: () {
                    context.read<PlayerProvider>().toggleUpNext();
                  },
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const UpNext(),
                      Consumer<PlayerProvider>(
                        builder: (context, playerProvider, _) {
                          print(playerProvider.selectedIndex);
                          return const Text("S");
                          // return StreamBuilder<int?>(
                          //   stream: context.read<PlayerProvider>().currentIndex,
                          //   builder: (context, snapshot) {
                          //     print(snapshot.data);

                          //     // if (mediaItem == null) {
                          //     return const SizedBox.shrink();
                          //     // }
                          //     // PlayerSongListModel? metadata;
                          //     // // try {
                          //     // //   metadata = mediaItem!
                          //     // //       .effectiveSequence[state.currentIndex + 1]
                          //     // //       .tag as PlayerSongListModel;
                          //     // // } catch (e) {
                          //     // //   metadata = null;
                          //     // // }
                          //     // return Text(
                          //     //   metadata != null
                          //     //       ? mediaItem.title.toString()
                          //     //       : "",
                          //     //   style: fontWeight400(size: 14.0),
                          //     // );
                          //   },
                          // );
                        },
                      )
                    ],
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_up),
                ),
              );
      },
    );
  }
}

class UpNextExpandableWidget extends StatelessWidget {
  const UpNextExpandableWidget({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final PlayerScreen widget;

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(builder: (context, pro, _) {
      return SizedBox(
        child: pro.isUpNextShow ? const UpNextExpandable() : const EmptyBox(),
      );
    });
  }
}
