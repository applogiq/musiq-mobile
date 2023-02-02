import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musiq/src/features/common/provider/pop_up_provider.dart';
import 'package:musiq/src/features/player/provider/player_provider.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/container/custom_color_container.dart';
import '../../../../constants/constant.dart';
import '../../domain/model/player_song_list_model.dart';

class UpNextExpandable extends StatelessWidget {
  const UpNextExpandable({
    Key? key,
    // required this.playerModel,
  }) : super(key: key);

  // final PlayerModel playerModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.fromLTRB(0, 4, 0, 0),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(33, 33, 44, 1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          ListTile(
            title: const UpNext(),
            trailing: InkWell(
                onTap: () {
                  context.read<PlayerProvider>().toggleUpNext();
                },
                child: const Icon(Icons.keyboard_arrow_down_rounded)),
          ),
          const Expanded(child: SongReorderListViewWidget())

          // ReorderListUpNextSongTile(
          //     playScreenModel: playerModel.collectionViewAllModel, index: 0)
        ],
      ),
    );
  }
}

class SongReorderListViewWidget extends StatefulWidget {
  const SongReorderListViewWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<SongReorderListViewWidget> createState() =>
      _SongReorderListViewWidgetState();
}

class _SongReorderListViewWidgetState extends State<SongReorderListViewWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SequenceState?>(
        stream: context.read<PlayerProvider>().player.sequenceStateStream,
        builder: (context, snapshot) {
          final state = snapshot.data;
          if (state?.sequence.isEmpty ?? true) {
            return const ColoredBox(
              color: Colors.black,
            );
          }
          return ReorderableListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: state!.effectiveSequence.length,
            itemBuilder: (context, index) {
              var metadata =
                  state.effectiveSequence[index].tag as PlayerSongListModel;
              return Container(
                key: Key(index.toString()),
                padding: const EdgeInsets.symmetric(vertical: 4),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    ReorderableDragStartListener(
                      index: index,
                      enabled: index != state.currentIndex,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Icon(
                          index == state.currentIndex
                              ? Icons.play_arrow_rounded
                              : Icons.view_stream_rounded,
                          color: index == state.currentIndex
                              ? CustomColor.secondaryColor
                              : Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CustomColorContainer(
                        child: Image.network(
                          metadata.imageUrl,
                          height: 70,
                          width: 70,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 9,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                metadata.title,
                                style: fontWeight400(
                                    color: index == state.currentIndex
                                        ? CustomColor.secondaryColor
                                        : Colors.white),
                              ),
                              Text(
                                metadata.musicDirectorName,
                                style: fontWeight400(
                                    size: 12.0,
                                    color: index == state.currentIndex
                                        ? CustomColor.secondaryColor
                                        : CustomColor.subTitle),
                              ),
                            ],
                          ),
                        )),
                    Expanded(
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
                        onSelected: (value) {
                          switch (value) {
                            case PopUpConstants.deleteInQueue:
                              context
                                  .read<PopUpProvider>()
                                  .deleteInQueue(index, context);
                              break;
                            case PopUpConstants.addToFavourites:
                              context
                                  .read<PopUpProvider>()
                                  .addToFavourites(metadata.id, context);
                              break;
                            case PopUpConstants.addToPlaylist:
                              context
                                  .read<PopUpProvider>()
                                  .goToPlaylist(metadata.id, context);

                              break;
                            case PopUpConstants.songInfo:
                              context
                                  .read<PopUpProvider>()
                                  .goToSongInfo(metadata.id, context);

                              break;
                          }
                          print(value);
                          // switch (value) {
                          //   case 1:
                          // }
                          // if (value == 3) {
                          //   context
                          //       .read<PlayerProvider>()
                          //       .deleteSongInQueue(index);
                          //   // context
                          //   //     .read<ViewAllProvider>()
                          //   //     .addQueue(widget.status, context);
                          // }
                        },
                        itemBuilder: (ctx) => [
                          const PopupMenuItem(
                            value: PopUpConstants.addToFavourites,
                            child: Text(ConstantText.addFavourites),
                          ),
                          const PopupMenuItem(
                            value: PopUpConstants.addToPlaylist,
                            child: Text(ConstantText.addPlaylist),
                          ),
                          const PopupMenuItem(
                            value: PopUpConstants.deleteInQueue,
                            child: Text(ConstantText.deleteInQueue),
                          ),
                          const PopupMenuItem(
                            value: PopUpConstants.songInfo,
                            child: Text(ConstantText.songInfo),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
            shrinkWrap: true,
            onReorder: (oldIndex, newIndex) {
              if (newIndex != state.currentIndex &&
                  oldIndex != state.currentIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex = newIndex - 1;
                  }
                  final element = state.effectiveSequence.removeAt(oldIndex);
                  state.effectiveSequence.insert(newIndex, element);
                });
              }
            },
          );
        });
  }
}

class UpNext extends StatelessWidget {
  const UpNext({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "Up next",
      style: fontWeight500(size: 16.0),
    );
  }
}
