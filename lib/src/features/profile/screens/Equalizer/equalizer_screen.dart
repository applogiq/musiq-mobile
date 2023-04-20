import 'package:flutter/material.dart';
import 'dart:async';

import 'package:equalizer_flutter/equalizer_flutter.dart';
import 'package:musiq/src/features/home/widgets/bottom_navigation_bar_widget.dart';
import 'package:musiq/src/features/player/provider/player_provider.dart';
import 'package:musiq/src/features/player/screen/player_screen/player_screen.dart';
import 'package:provider/provider.dart';

// void main() {
//   runApp(const MyApp());
// }

class Equalizer extends StatefulWidget {
  const Equalizer({Key? key}) : super(key: key);

  @override
  State<Equalizer> createState() => _EqualizerState();
}

class _EqualizerState extends State<Equalizer> {
  bool enableCustomEQ = false;

  @override
  void initState() {
    super.initState();
    EqualizerFlutter.init(0);
  }

  @override
  void dispose() {
    EqualizerFlutter.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Consumer<PlayerProvider>(builder: (context, pro, _) {
        return pro.isPlaying
            ? MiniPlayer(onChange: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayerScreen(
                        onTap: () => Navigator.pop(context),
                      ),
                    ));
              })
            : const SizedBox.shrink();
      }),
      // backgroundColor: Colors.white,
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10.0),
            // Center(
            //   child: Builder(
            //     builder: (context) {
            //       return ElevatedButton.icon(
            //         icon: const Icon(Icons.equalizer),
            //         label: const Text('Open device equalizer'),
            //         // color: Colors.blue,
            //         // textColor: Colors.white,
            //         onPressed: () async {
            //           try {
            //             await EqualizerFlutter.open(0);
            //           } on PlatformException catch (e) {
            //             toastMessage("${e.message}\n${e.details}", Colors.black,
            //                 Colors.white);
            //             final snackBar = const SnackBar(
            //               behavior: SnackBarBehavior.floating,
            //               content: Text(''),
            //             );
            //             // Scaffold.of(context).showSnackBar(snackBar);
            //           }
            //         },
            //       );
            //     },
            //   ),
            // ),
            const SizedBox(height: 10.0),
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.grey.withOpacity(0.1),
              child: SwitchListTile(
                activeColor: const Color.fromRGBO(254, 86, 49, 1),
                activeTrackColor: const Color.fromRGBO(255, 255, 255, 1),
                inactiveThumbColor: const Color.fromRGBO(255, 255, 255, 0.4),
                inactiveTrackColor: const Color.fromRGBO(254, 86, 49, 1),
                title: const Text(
                  'Equaliser',
                  style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1), fontSize: 20),
                ),
                value: enableCustomEQ,
                onChanged: (value) {
                  EqualizerFlutter.setEnabled(value);
                  setState(() {
                    enableCustomEQ = value;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder<List<int>>(
              future: EqualizerFlutter.getBandLevelRange(),
              builder: (context, snapshot) {
                return snapshot.connectionState == ConnectionState.done
                    ? CustomEQ(enableCustomEQ, snapshot.data!)
                    : const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomEQ extends StatefulWidget {
  const CustomEQ(this.enabled, this.bandLevelRange);

  final bool enabled;
  final List<int> bandLevelRange;

  @override
  _CustomEQState createState() => _CustomEQState();
}

class _CustomEQState extends State<CustomEQ> {
  late double min, max;
  String? _selectedValue;
  late Future<List<String>> fetchPresets;

  @override
  void initState() {
    super.initState();
    min = widget.bandLevelRange[0].toDouble();
    max = widget.bandLevelRange[1].toDouble();
    fetchPresets = EqualizerFlutter.getPresetNames();
  }

  @override
  Widget build(BuildContext context) {
    int bandId = 0;

    return FutureBuilder<List<int>>(
      future: EqualizerFlutter.getCenterBandFreqs(),
      builder: (context, snapshot) {
        return snapshot.connectionState == ConnectionState.done
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: _buildPresets(),
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: snapshot.data!
                        .map((freq) => _buildSliderBand(freq, bandId))
                        .toList(),
                  ),
                  // const Divider(),
                ],
              )
            : const CircularProgressIndicator();
      },
    );
  }

  Widget _buildSliderBand(int freq, int bandId) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 250,
            child: FutureBuilder<int>(
              future: EqualizerFlutter.getBandLevel(bandId),
              builder: (context, snapshot) {
                var data = snapshot.data?.toDouble() ?? 0.0;
                return RotatedBox(
                  quarterTurns: 1,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                        trackHeight: 1, trackShape: SliderCustomTrackShape()),
                    child: Center(
                      child: Slider(
                        thumbColor: const Color.fromRGBO(255, 255, 255, 2),
                        activeColor: const Color.fromRGBO(254, 86, 49, 1),
                        inactiveColor: const Color.fromRGBO(255, 255, 255, 1),
                        min: min,
                        max: max,
                        value: data,
                        onChanged: (lowerValue) {
                          EqualizerFlutter.setBandLevel(
                              bandId, lowerValue.toInt());
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Text(
            '${freq ~/ 1000} Hz',
            style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
          ),
        ],
      ),
    );
  }

  Widget _buildPresets() {
    return FutureBuilder<List<String>>(
      future: fetchPresets,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final presets = snapshot.data;
          if (presets!.isEmpty) return const Text('No presets available!');
          return DropdownButtonFormField(
            decoration: const InputDecoration(
              labelText: 'Available Presets',
              border: OutlineInputBorder(),
            ),
            value: _selectedValue,
            onChanged: widget.enabled
                ? (String? value) {
                    EqualizerFlutter.setPreset(value!);
                    setState(() {
                      _selectedValue = value;
                    });
                  }
                : null,
            items: presets.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class SliderCustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double? trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop = (parentBox.size.height) / 2;
    const double trackWidth = 230;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight!);
  }
}




// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:musiq/src/features/player/provider/player_provider.dart';
// // import 'package:musiq/src/features/player/widget/player/progress_bar_widget.dart';
// import 'package:musiq/src/features/profile/screens/Equalizer/equalizer_alert_card.dart';
// import 'package:provider/provider.dart';
// import 'package:rxdart/rxdart.dart';
// import 'dart:async';

// class Equalizer extends StatefulWidget {
//   const Equalizer({super.key});

//   @override
//   State<Equalizer> createState() => _EqualizerState();
// }

// class _EqualizerState extends State<Equalizer> with WidgetsBindingObserver {
//   AndroidEqualizer equalizer = AndroidEqualizer();

//   final _loudnessEnhancer = AndroidLoudnessEnhancer();
//   ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: []);

//   late final AudioPlayer _player = AudioPlayer(
//     handleInterruptions: true,
//     androidApplyAudioAttributes: true,
//     handleAudioSessionActivation: true,
//     audioPipeline: AudioPipeline(
//       androidAudioEffects: [
//         _loudnessEnhancer,
//         equalizer,
//       ],
//     ),
//   );

//   @override
//   void initState() {
//     super.initState();
//     ambiguate(WidgetsBinding.instance)!.addObserver(this);
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await Provider.of<PlayerProvider>(context, listen: false).init();
//     });
//   }

//   @override
//   void dispose() {
//     ambiguate(WidgetsBinding.instance)!.removeObserver(this);
//     _player.dispose();
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.paused) {
//       // Release the player's resources when not in use. We use "stop" so that
//       // if the app resumes later, it will still remember what position to
//       // resume from.
//       _player.stop();
//     }
//   }

//   Stream<PositionData> get _positionDataStream =>
//       Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
//           _player.positionStream,
//           _player.bufferedPositionStream,
//           _player.durationStream,
//           (position, bufferedPosition, duration) => PositionData(
//               position, bufferedPosition, duration ?? Duration.zero));

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             StreamBuilder<bool>(
//               stream: _loudnessEnhancer.enabledStream,
//               builder: (context, snapshot) {
//                 final enabled = snapshot.data ?? false;
//                 return SwitchListTile(
//                   title: const Text('Loudness Enhancer'),
//                   value: enabled,
//                   onChanged: _loudnessEnhancer.setEnabled,
//                 );
//               },
//             ),
//             LoudnessEnhancerControls(loudnessEnhancer: _loudnessEnhancer),
//             StreamBuilder<bool>(
//               stream: equalizer.enabledStream,
//               builder: (context, snapshot) {
//                 final enabled = snapshot.data ?? false;
//                 return SwitchListTile(
//                   title: const Text('Equalizer'),
//                   value: enabled,
//                   onChanged: equalizer.setEnabled,
//                 );
//               },
//             ),
//             Expanded(child: EqualizerControls(equalizer: equalizer)),
//             ControlButtons(_player),
//             StreamBuilder<PositionData>(
//               stream: _positionDataStream,
//               builder: (context, snapshot) {
//                 final positionData = snapshot.data;
//                 return SeekBar(
//                   duration: positionData?.duration ?? Duration.zero,
//                   position: positionData?.position ?? Duration.zero,
//                   bufferedPosition:
//                       positionData?.bufferedPosition ?? Duration.zero,
//                   onChangeEnd: _player.seek,
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ControlButtons extends StatelessWidget {
//   final AudioPlayer player;

//   const ControlButtons(this.player, {Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         IconButton(
//           icon: const Icon(Icons.volume_up),
//           onPressed: () {
//             showSliderDialog(
//               context: context,
//               title: "Adjust volume",
//               divisions: 10,
//               min: 0.0,
//               max: 1.0,
//               value: player.volume,
//               stream: player.volumeStream,
//               onChanged: player.setVolume,
//             );
//           },
//         ),
//         StreamBuilder<PlayerState>(
//           stream: player.playerStateStream,
//           builder: (context, snapshot) {
//             final playerState = snapshot.data;
//             final processingState = playerState?.processingState;
//             final playing = playerState?.playing;
//             if (processingState == ProcessingState.loading ||
//                 processingState == ProcessingState.buffering) {
//               return Container(
//                 margin: const EdgeInsets.all(8.0),
//                 width: 64.0,
//                 height: 64.0,
//                 child: const CircularProgressIndicator(),
//               );
//             } else if (playing != true) {
//               return IconButton(
//                 icon: const Icon(Icons.play_arrow),
//                 iconSize: 64.0,
//                 onPressed: player.play,
//               );
//             } else if (processingState != ProcessingState.completed) {
//               return IconButton(
//                 icon: const Icon(Icons.pause),
//                 iconSize: 64.0,
//                 onPressed: player.pause,
//               );
//             } else {
//               return IconButton(
//                 icon: const Icon(Icons.replay),
//                 iconSize: 64.0,
//                 onPressed: () => player.seek(Duration.zero),
//               );
//             }
//           },
//         ),
//         StreamBuilder<double>(
//           stream: player.speedStream,
//           builder: (context, snapshot) => IconButton(
//             icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
//                 style: const TextStyle(fontWeight: FontWeight.bold)),
//             onPressed: () {
//               showSliderDialog(
//                 context: context,
//                 title: "Adjust speed",
//                 divisions: 10,
//                 min: 0.5,
//                 max: 1.5,
//                 value: player.speed,
//                 stream: player.speedStream,
//                 onChanged: player.setSpeed,
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

// class EqualizerControls extends StatelessWidget {
//   final AndroidEqualizer equalizer;

//   const EqualizerControls({
//     Key? key,
//     required this.equalizer,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<AndroidEqualizerParameters>(
//       future: equalizer.parameters,
//       builder: (context, snapshot) {
//         final parameters = snapshot.data;
//         print(parameters);
//         if (parameters == null) return const Text("data");
//         return Row(
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             for (var band in parameters.bands)
//               Column(
//                 children: [
//                   StreamBuilder<double>(
//                     stream: band.gainStream,
//                     builder: (context, snapshot) {
//                       return VerticalSlider(
//                         min: parameters.minDecibels,
//                         max: parameters.maxDecibels,
//                         value: band.gain,
//                         onChanged: band.setGain,
//                       );
//                     },
//                   ),
//                   Text('${band.centerFrequency.round()} Hz'),
//                 ],
//               ),
//           ],
//         );
//       },
//     );
//   }
// }

// class VerticalSlider extends StatelessWidget {
//   final double value;
//   final double min;
//   final double max;
//   final ValueChanged<double>? onChanged;

//   const VerticalSlider({
//     Key? key,
//     required this.value,
//     this.min = 0.0,
//     this.max = 1.0,
//     this.onChanged,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return FittedBox(
//       fit: BoxFit.fitHeight,
//       alignment: Alignment.bottomCenter,
//       child: Transform.rotate(
//         angle: -pi / 2,
//         child: Container(
//           width: 400.0,
//           height: 400.0,
//           alignment: Alignment.center,
//           child: Slider(
//             activeColor: Colors.amber,
//             inactiveColor: Colors.red,
//             value: value,
//             min: min,
//             max: max,
//             onChanged: onChanged,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class LoudnessEnhancerControls extends StatelessWidget {
//   final AndroidLoudnessEnhancer loudnessEnhancer;

//   const LoudnessEnhancerControls({
//     Key? key,
//     required this.loudnessEnhancer,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<double>(
//       stream: loudnessEnhancer.targetGainStream,
//       builder: (context, snapshot) {
//         final targetGain = snapshot.data ?? 0.0;
//         return Slider(
//           min: -1.0,
//           max: 1.0,
//           value: targetGain,
//           onChanged: loudnessEnhancer.setTargetGain,
//           label: 'foo',
//         );
//       },
//     );
//   }
// }
