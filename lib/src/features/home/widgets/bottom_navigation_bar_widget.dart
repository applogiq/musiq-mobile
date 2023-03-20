// import 'package:audio_service/audio_service.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musiq/src/core/extensions/string_extension.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import '../../../common_widgets/box/horizontal_box.dart';
import '../../../core/constants/color.dart';
import '../../../core/constants/constant.dart';
import '../../../core/constants/images.dart';
import '../../player/provider/player_provider.dart';
import '../../player/widget/player/player_button_widget.dart';

class BottomNavigationBarWithMiniPlayer extends StatelessWidget {
  const BottomNavigationBarWithMiniPlayer({super.key, required this.width});
  final double width;

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(builder: (context, pro, _) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomNavigationBarWidget(
            width: width,
          ),
        ],
      );
    });
  }
}

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key, required this.onChange});
  final Function onChange;

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  Color miniPlayerColor = const Color.fromRGBO(22, 21, 28, 1);
  Random random = Random();

  Future<Color> getImagePalette(ImageProvider imageProvider) async {
    try {
      final PaletteGenerator paletteGenerator =
          await PaletteGenerator.fromImageProvider(imageProvider);
      miniPlayerColor =
          paletteGenerator.darkMutedColor!.color.withOpacity(0.98);
      if (mounted) {
        setState(() {});
      }
      return paletteGenerator.dominantColor!.color;
    } catch (e) {
      miniPlayerColor = CustomColor.bg;
      if (mounted) {
        setState(() {});
      }
      return CustomColor.bg;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 60,
          color: context.read<PlayerProvider>().miniPlayerBackground,
          child: MiniPlayerController(
            onTap: widget.onChange,
          ),
        )
        // StreamBuilder<int?>(
        //     stream: context.read<PlayerProvider>().player.currentIndexStream,
        //     builder: (context, snapshot) {
        //       print("Index stream");
        //       if (snapshot.connectionState == ConnectionState.waiting) {
        //         return Container(
        //           height: 60,
        //           color: miniPlayerColor,
        //         );
        //       } else {
        //         return
        //       }
        //       // print("ARE you wait for me");
        //       // final state = snapshot.data;

        //       // return Container(
        //       //   height: 60,
        //       //   color: CustomColor.miniPlayerBackgroundColors[Random()
        //       //       .nextInt(CustomColor.miniPlayerBackgroundColors.length)],
        //       // );
        //     }),

        // StreamBuilder<SequenceState?>(
        //     stream: context.read<PlayerProvider>().player.sequenceStateStream,
        //     builder: (context, snapshot) {
        //       print("Wait for you");
        //       final state = snapshot.data;
        //       if (state?.sequence.isEmpty ?? true) {
        //         return const SizedBox();
        //       }

        //       final metadata = state!.currentSource!.tag as MediaItem;

        //       return Consumer<PlayerProvider>(builder: (context, pro, _) {
        //         return StreamBuilder<int?>(
        //             stream: context
        //                 .read<PlayerProvider>()
        //                 .player
        //                 .currentIndexStream,
        //             builder: (context, snapshot) {
        //               return FutureBuilder(
        //                   future: getImagePalette(
        //                       NetworkImage(metadata.artUri.toString())),
        //                   builder: (context, snapshot) {
        //                     return Container(
        //                       height: 60,
        //                       color: miniPlayerColor,
        //                       child: Row(
        //                         children: [
        //                           GestureDetector(
        //                             onTap: () {
        //                               context
        //                                   .read<PlayerProvider>()
        //                                   .isUpNextShow = false;
        //                               widget.onChange();
        //                             },
        //                             child: Container(
        //                               height: 60,
        //                               width: 60,
        //                               padding: const EdgeInsets.all(6),
        //                               clipBehavior: Clip.hardEdge,
        //                               decoration: BoxDecoration(
        //                                   borderRadius:
        //                                       BorderRadius.circular(12)),
        //                               child: Image.network(
        //                                 metadata.artUri.toString(),
        //                                 fit: BoxFit.cover,
        //                                 errorBuilder:
        //                                     (context, error, stackTrace) =>
        //                                         Image.asset(Images.noSong),
        //                               ),
        //                             ),
        //                           ),
        // const HorizontalBox(width: 10),
        // Expanded(
        //   child: GestureDetector(
        //     behavior: HitTestBehavior.opaque,
        //     onTap: () {
        //       context
        //           .read<PlayerProvider>()
        //           .isUpNextShow = false;
        //       widget.onChange();
        //     },
        //     child: SizedBox(
        //       child: Column(
        //         mainAxisSize: MainAxisSize.max,
        //         crossAxisAlignment:
        //             CrossAxisAlignment.start,
        //         mainAxisAlignment:
        //             MainAxisAlignment.center,
        //         children: [
        //           Text(
        //             metadata.title,
        //             maxLines: 1,
        //             style: const TextStyle(
        //               overflow: TextOverflow.ellipsis,
        //             ),
        //           ),
        //           Text(
        //             metadata.album!,
        //             maxLines: 1,
        //             style: const TextStyle(
        //               overflow: TextOverflow.ellipsis,
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        //                           StreamBuilder<SequenceState?>(
        //                             stream: pro.player.sequenceStateStream,
        //                             builder: (context, snapshot) {
        // return IconButton(
        //   padding: const EdgeInsets.all(0),
        //   onPressed: pro.player.hasPrevious
        //       ? () {
        //           context
        //               .read<PlayerProvider>()
        //               .playPrev();
        //         }
        //       : null,
        //   icon: const Icon(
        //       Icons.skip_previous_rounded),
        // );
        //                             },
        //                           ),
        //                           StreamBuilder<PlayerState>(
        //                               stream: pro.player.playerStateStream,
        //                               builder: (context, snapshot) {
        //                                 final playerState = snapshot.data;
        //                                 final processingState =
        //                                     playerState?.processingState;
        //                                 final playing = playerState?.playing;

        //                                 return InkWell(
        //                                   onTap: () {
        //                                     context
        //                                         .read<PlayerProvider>()
        //                                         .playOrPause(
        //                                             playerState!, context);
        //                                   },
        //                                   child: (processingState ==
        //                                               ProcessingState.loading ||
        //                                           processingState ==
        //                                               ProcessingState.buffering)
        //                                       ? const CircularNotificationPlayerWidget()
        //                                       : PlayButtonWidget(
        //                                           size: 24.0,
        //                                           padding: 4.0,
        //                                           iconColor:
        //                                               const Color.fromRGBO(
        //                                                   255, 255, 255, 0.8),
        //                                           bgColor: const Color.fromRGBO(
        //                                               254, 86, 49, 1),
        //                                           icon: playing != true
        //                                               ? Icons.play_arrow
        //                                               : processingState !=
        //                                                       ProcessingState
        //                                                           .completed
        //                                                   ? Icons.pause_rounded
        //                                                   : Icons.replay,
        //                                         ),
        //                                 );
        //                               }),
        //                           StreamBuilder<SequenceState?>(
        //                               stream: pro.player.sequenceStateStream,
        //                               builder: (context, snapshot) {
        //                                 return IconButton(
        //                                   padding: const EdgeInsets.all(0),
        //                                   onPressed: pro.player.hasNext
        //                                       ? () {
        //                                           context
        //                                               .read<PlayerProvider>()
        //                                               .playNext();
        //                                         }
        //                                       : null,
        //                                   icon: const Icon(
        //                                       Icons.skip_next_rounded),
        //                                 );
        //                               }),
        //                         ],
        //                       ),
        //                     );
        //                   });
        //             });
        //       });
        //     }),
      ],
    );
  }
}

class CircularNotificationPlayerWidget extends StatelessWidget {
  const CircularNotificationPlayerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      // margin: const EdgeInsets.all(12.0),
      child: CircularProgressIndicator(
        color: CustomColor.secondaryColor,
      ),
    );
  }
}

class MiniPlayerController extends StatelessWidget {
  const MiniPlayerController({super.key, required this.onTap});
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(builder: (context, pro, _) {
      return StreamBuilder<SequenceState?>(
          stream: pro.player.sequenceStateStream,
          builder: (context, snapshot) {
            print("Sequence stream");
            final state = snapshot.data;
            if (state?.sequence.isEmpty ?? true) {
              return const SizedBox();
            }

            final metadata = state!.currentSource!.tag as MediaItem;
            return Stack(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        pro.isUpNextShow = false;
                        onTap();
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        margin: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 12),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12)),
                        child: pro.isPlayingLoad
                            ? Image.asset(Images.loaderImage)
                            : Image.network(
                                metadata.artUri.toString(),
                                fit: BoxFit.fill,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset(Images.noSong),
                              ),
                      ),
                    ),
                    const HorizontalBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          context.read<PlayerProvider>().isUpNextShow = false;
                          onTap();
                        },
                        child: SizedBox(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                pro.isPlayingLoad
                                    ? ""
                                    : metadata.title
                                        .toString()
                                        .capitalizeFirstLetter(),
                                maxLines: 1,
                                style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                pro.isPlayingLoad
                                    ? ""
                                    : metadata.album
                                        .toString()
                                        .capitalizeFirstLetter(),
                                maxLines: 1,
                                style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: pro.player.hasPrevious
                          ? () {
                              pro.playPrev();
                            }
                          : null,
                      icon: const Icon(Icons.skip_previous_rounded),
                    ),
                    StreamBuilder<PlayerState>(
                        stream: pro.player.playerStateStream,
                        builder: (context, snapshot) {
                          final playerState = snapshot.data;
                          final processingState = playerState?.processingState;
                          final playing = playerState?.playing;

                          return InkWell(
                            onTap: () {
                              pro.playOrPause(playerState!, context);
                            },
                            child: (processingState ==
                                        ProcessingState.loading ||
                                    processingState ==
                                        ProcessingState.buffering)
                                ? const CircularNotificationPlayerWidget()
                                : PlayButtonWidget(
                                    size: 24.0,
                                    padding: 4.0,
                                    iconColor: const Color.fromRGBO(
                                        255, 255, 255, 0.8),
                                    bgColor:
                                        const Color.fromRGBO(254, 86, 49, 1),
                                    icon: playing != true
                                        ? Icons.play_arrow
                                        : processingState !=
                                                ProcessingState.completed
                                            ? Icons.pause_rounded
                                            : Icons.replay,
                                  ),
                          );
                        }),
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: pro.player.hasNext
                          ? () {
                              pro.playNext();
                            }
                          : null,
                      icon: const Icon(Icons.skip_next_rounded),
                    ),
                  ],
                ),
                pro.isPlayingLoad
                    ? Positioned.fill(
                        child: ColoredBox(
                        color: Colors.grey.withOpacity(0.4),
                      ))
                    : const SizedBox.shrink()
              ],
            );
          });
    });
  }
}
