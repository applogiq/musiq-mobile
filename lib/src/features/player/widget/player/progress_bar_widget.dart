import 'dart:math';

import 'package:audio_service/audio_service.dart';
// import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musiq/src/core/constants/constant.dart';
import 'package:musiq/src/core/package/audio_progress_bar.dart';
import 'package:provider/provider.dart';
// import 'package:wave_progress_bars/wave_progress_bars.dart';

import '../../provider/player_provider.dart';

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

class ProgressBarWidget extends StatefulWidget {
  const ProgressBarWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<ProgressBarWidget> createState() => _ProgressBarWidgetState();
}

class _ProgressBarWidgetState extends State<ProgressBarWidget> {
  // late final PlayerController playerControllers;
  AudioPlayer player = AudioPlayer();
  final Color clr = const Color.fromRGBO(22, 21, 28, 1);

  @override
  void initState() {
    // playerControllers = PlayerController();
    super.initState();
  }

  @override
  void dispose() {
    // playerControllers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<double> val = [];
    var range = Random();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Consumer<PlayerProvider>(builder: (context, pro, _) {
        return StreamBuilder<SequenceState?>(
            stream: pro.player.sequenceStateStream,
            builder: (context, snapshot) {
              for (var i = 0; i < 100; i++) {
                val.add(range.nextInt(70) * 1.0);
              }
              final state = snapshot.data;
              if (state?.sequence.isEmpty ?? true) {
                return const SizedBox.shrink();
              }
              // ignore: unused_local_variable
              final metadata = state!.currentSource!.tag as MediaItem;
              return StreamBuilder<Duration>(builder: (context, snapshot) {
                return Column(
                  children: [
                    // RectangleWaveform(
                    //     elapsedDuration:
                    //         Duration(milliseconds: pro.totalDurationValue),
                    //     maxDuration:
                    //         Duration(milliseconds: pro.bufferDurationValue),
                    //     samples: const [
                    //       10,
                    //       5,
                    //       2,
                    //       10,
                    //       5,
                    //       0,
                    //       9,
                    //       1,
                    //       7,
                    //       8,
                    //       9,
                    //       4,
                    //       5,
                    //       6,
                    //       1,
                    //       23,
                    //       5,
                    //       4,
                    //       6,
                    //       8,
                    //       7,
                    //     ],
                    //     height: 50,
                    //     width: double.maxFinite),

                    ProgressBar(
                      thumbGlowRadius: 20,
                      // thumbGlowColor: Colors.white.withOpacity(0.1),
                      progress:
                          Duration(milliseconds: pro.progressDurationValue),
                      buffered: Duration(milliseconds: pro.bufferDurationValue),
                      total: Duration(milliseconds: pro.totalDurationValue),
                      // total: Duration(
                      //     milliseconds:
                      //         totalDuration(metadata.duration.toString())),
                      progressBarColor: CustomColor.secondaryColor,
                      baseBarColor: Colors.white.withOpacity(0.24),
                      bufferedBarColor: Colors.transparent,
                      thumbColor: Colors.white,
                      barHeight: 3.0,
                      thumbRadius: 4.0,
                      onSeek: (duration) {
                        pro.seekDuration(duration);
                        // songController.seekDuration(duration);
                      },
                    ),
                  ],
                );
                //     Column(
                //   children: [
                //     Stack(
                //       children: [
                //         ProgressBar(
                //           barCapShape: BarCapShape.square,
                //           thumbCanPaintOutsideBar: false,
                //           thumbGlowRadius: 0,
                //           // thumbGlowColor: Colors.white.withOpacity(0.1),
                //           progress:
                //               Duration(milliseconds: pro.progressDurationValue),
                //           buffered:
                //               Duration(milliseconds: pro.bufferDurationValue),
                //           total: Duration(milliseconds: pro.totalDurationValue),
                //           // total: Duration(
                //           //     milliseconds:
                //           //         totalDuration(metadata.duration.toString())),
                //           progressBarColor: CustomColor.secondaryColor,
                //           baseBarColor: Colors.white.withOpacity(0.24),
                //           bufferedBarColor: Colors.transparent,
                //           thumbColor: Colors.white,
                //           barHeight: 79.0,
                //           thumbRadius: 0.0,
                //           onSeek: (duration) {
                //             pro.seekDuration(duration);
                //             // songController.seekDuration(duration);
                //           },
                //         ),
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: const [
                //             ProgressContainer(),
                //             ProgressContainer(),
                //             ProgressContainer(),
                //             ProgressContainer(),
                //             ProgressContainer(),
                //             ProgressContainer(),
                //             ProgressContainer(),
                //             ProgressContainer(),
                //             ProgressContainer(),
                //             ProgressContainer(),
                //             ProgressContainer(),
                //             ProgressContainer(),
                //             ProgressContainer(),
                //             ProgressContainer(),
                //             ProgressContainer(),
                //             ProgressContainer(),
                //             ProgressContainer(),
                //             ProgressContainer(),
                //             ProgressContainer(),
                //             ProgressContainer(),
                //             ProgressContainer(),
                //             ProgressContainer(),
                //             ProgressContainer(),
                //             ProgressContainer(),
                //             ProgressContainer(),
                //             ProgressContainer(),
                //             ProgressContainer(),
                //             ProgressContainer(),
                //             ProgressContainer(),
                //             ProgressContainer(),
                //             ProgressContainer(),
                //             ProgressContainer(),
                //             ProgressContainer(),
                //             ProgressContainer(),
                //             ProgressContainer(),
                //             ProgressContainer(),
                //             ProgressContainer(),
                //             ProgressContainer(),
                //           ],
                //         )
                //         // Container(
                //         //   height: 80,
                //         //   width: double.infinity,
                //         //   color: Colors.transparent,
                //         //   child: Row(
                //         //     children: const [
                //         //       ProgressContainer(),
                //         //       ProgressContainer(),
                //         //       AllProgressWidget(),
                //         //       ProgressContainer(),
                //         //       AllProgressWidget(),
                //         //       ProgressContainer(),
                //         //       AllProgressWidget(),
                //         //       ProgressContainer(),
                //         //       AllProgressWidget(),
                //         //       ProgressContainer(),
                //         //       AllProgressWidget(),
                //         //       ProgressContainer(),
                //         //       AllProgressWidget(),
                //         //       ProgressContainer(),
                //         //       AllProgressWidget(),
                //         //       ProgressContainer(),
                //         //       AllProgressWidget(),
                //         //       ProgressContainer(),
                //         //       AllProgressWidget(),
                //         //       ProgressContainer(),
                //         //       ProgressContainer(),
                //         //       ProgressContainer(),
                //         //     ],
                //         //   ),
                //         // )
                //       ],
                //     ),
                //   ],
                // );
              });
            });
      }),
    );
  }
}

class ProgressContainer extends StatelessWidget {
  const ProgressContainer({super.key, this.height = 80, this.width = 7});
  final double height;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: const Color.fromRGBO(22, 21, 28, 1),
    );
  }
}

class ProgressColumnWidget extends StatelessWidget {
  const ProgressColumnWidget(
      {super.key, this.height = 30, this.width = 3, this.centerWidth = 10});
  final double height;
  final double width;
  final double centerWidth;
  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: height,
          width: width,
          color: const Color.fromRGBO(22, 21, 28, 1),
        ),
        SizedBox(
          height: centerWidth,
        ),
        Container(
          height: height,
          width: width,
          color: const Color.fromRGBO(22, 21, 28, 1),
        ),
      ],
    );
  }
}

class AllProgressWidget extends StatelessWidget {
  const AllProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        ProgressColumnWidget(),
        ProgressContainer(),
        ProgressColumnWidget(
          height: 25,
        ),
        ProgressContainer(),
        ProgressColumnWidget(
          height: 20,
        ),
        ProgressContainer(),
        ProgressColumnWidget(
          height: 25,
        ),
        ProgressContainer(),
        ProgressColumnWidget(
          height: 15,
        ),
        ProgressContainer(),
        ProgressColumnWidget(
          height: 25,
        ),
        ProgressContainer(),
        ProgressColumnWidget()
      ],
    );
  }
}
