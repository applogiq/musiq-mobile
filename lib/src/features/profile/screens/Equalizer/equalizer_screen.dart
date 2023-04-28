import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:equalizer_flutter/equalizer_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musiq/src/core/utils/size_config.dart';
import 'package:musiq/src/features/common/packages/shimmer/shimmer.dart';
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
  FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _getStoredValue();
    EqualizerFlutter.init(0);
  }

  Future<void> _getStoredValue() async {
    final value = await storage.read(key: 'enableCustomEQ');
    if (value != null) {
      setState(() {
        enableCustomEQ = value.toLowerCase() == 'true';
      });
    }
  }

  @override
  void dispose() {
    EqualizerFlutter.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar:
            Consumer<PlayerProvider>(builder: (context, pro, _) {
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
        backgroundColor: const Color.fromARGB(255, 36, 36, 36),
        body: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10.0),
              const SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.all(8),
                color: const Color.fromARGB(0, 61, 60, 60),
                child: SwitchListTile(
                  activeColor: const Color.fromRGBO(254, 86, 49, 1),
                  activeTrackColor: const Color.fromRGBO(255, 255, 255, 1),
                  inactiveThumbColor: const Color.fromRGBO(254, 86, 49, 1),
                  inactiveTrackColor: const Color.fromRGBO(255, 255, 255, 0.4),
                  title: Text(
                    'Equaliser',
                    style: TextStyle(
                        color: enableCustomEQ
                            ? const Color.fromRGBO(255, 255, 255, 1)
                            : Colors.grey,
                        fontSize: 20),
                  ),
                  value: enableCustomEQ,
                  onChanged: (value) async {
                    log(value.toString());

                    EqualizerFlutter.setEnabled(value);
                    log(value.toString());

                    setState(() {
                      enableCustomEQ = value;
                    });
                    log(value.toString());
                    await storage.write(
                        key: 'enableCustomEQ', value: value.toString());
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
                      ? CustomEQ(
                          enabled: enableCustomEQ,
                          bandLevelRange: snapshot.data!)
                      : const CircularProgressIndicator(
                          value: 0,
                          strokeWidth: 0,
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomEQ extends StatefulWidget {
  const CustomEQ(
      {required this.enabled, required this.bandLevelRange, super.key});

  final bool enabled;
  final List<int> bandLevelRange;

  @override
  State<CustomEQ> createState() => _CustomEQState();
}

class _CustomEQState extends State<CustomEQ> {
  late double min, max;
  String? _selectedValue;
  late Future<List<String>> fetchPresets;
  late List<double> _sliderValues;
  FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    min = widget.bandLevelRange[0].toDouble();
    max = widget.bandLevelRange[1].toDouble();
    fetchPresets = EqualizerFlutter.getPresetNames();
    // _sliderValues = List.filled(EqualizerFlutter.numberOfBands, 0.0);
    _loadSelectedValue();
  }

  Future<void> _saveSliderValues() async {
    await storage.write(key: 'sliderValues', value: _sliderValues.toString());
  }

  void _loadSelectedValue() async {
    final selectedValue = await storage.read(key: 'selected_preset');
    setState(() {
      _selectedValue = selectedValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    int bandId = 0;

    return FutureBuilder<List<int>>(
      future: EqualizerFlutter.getCenterBandFreqs(),
      builder: (context, snapshot) {
        // log(snapshot.data.toString());
        // log(snapshot.stackTrace.toString());
        return snapshot.connectionState == ConnectionState.done
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: _buildPresets(widget.enabled),
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  // EqualizerFlutter.setEnabled(false)?
                  widget.enabled
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: snapshot.data!
                              .map((item) => BuildSliderBand(
                                    freq: item,
                                    bandId: bandId++,
                                    min: min,
                                    max: max,
                                    activeColor:
                                        const Color.fromRGBO(254, 86, 49, 1),
                                    tuumbColor:
                                        const Color.fromRGBO(255, 255, 255, 2),
                                    enable: widget.enabled,
                                    inactiveRangeColor:
                                        const Color.fromRGBO(255, 255, 255, 1),
                                  ))
                              .toList(),
                        )
                      : Stack(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: snapshot.data!
                                  .map((item) => BuildSliderBand(
                                        freq: item,
                                        bandId: bandId++,
                                        min: min,
                                        max: max,
                                        activeColor: const Color.fromARGB(
                                            102, 108, 102, 102),
                                        tuumbColor: Colors.grey,
                                        enable: widget.enabled,
                                        inactiveRangeColor: Colors.grey,
                                      ))
                                  .toList(),
                            ),
                            Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  color: Colors.transparent,
                                ))
                          ],
                        )
                  // const Divider(),
                ],
              )
            : const CircularProgressIndicator(
                value: 0,
                strokeWidth: 0,
              );
      },
    );
  }

  Widget _buildPresets(bool isEnable) {
    return FutureBuilder<List<String>>(
      future: fetchPresets,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final presets = snapshot.data;
          if (presets!.isEmpty) return const Text('No presets available!');
          return DropdownButtonFormField(
            iconEnabledColor: Colors.white,
            iconDisabledColor: Colors.grey,
            decoration: InputDecoration(
              labelStyle:
                  TextStyle(color: isEnable ? Colors.white : Colors.grey),
              labelText: 'Available Presets',
              border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red)),
            ),
            value: _selectedValue,
            onChanged: widget.enabled
                ? (String? value) async {
                    await storage.write(key: 'selected_preset', value: value!);
                    EqualizerFlutter.setPreset(value);
                    setState(() {
                      _selectedValue = value;
                    });
                  }
                : null,
            items: presets.map((String value) {
              // print(_selectedValue);
              // log(value.toString());
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          return const SizedBox(
            height: 100,
            // color: Colors.grey,
            child: CircularProgressIndicator(),
          );
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

class BuildSliderBand extends StatefulWidget {
  final int freq;
  final int bandId;
  final double min;
  final double max;
  final Color activeColor;
  final Color tuumbColor;
  final Color inactiveRangeColor;
  final bool enable;

  const BuildSliderBand(
      {super.key,
      required this.freq,
      required this.bandId,
      required this.min,
      required this.max,
      required this.activeColor,
      required this.tuumbColor,
      required this.inactiveRangeColor,
      required this.enable});

  @override
  State<BuildSliderBand> createState() => BuildSliderBandState();
}

class BuildSliderBandState extends State<BuildSliderBand> {
  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 250,
            child: FutureBuilder<int>(
              future: EqualizerFlutter.getBandLevel(widget.bandId),
              builder: (context, snapshot) {
                var data = snapshot.data?.toDouble() ?? 0.0;
                return RotatedBox(
                  quarterTurns: 3,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                        trackHeight: 2, trackShape: SliderCustomTrackShape()),
                    child: Center(
                      child: Slider(
                        thumbColor: widget.tuumbColor,
                        activeColor: widget.activeColor,
                        inactiveColor: widget.inactiveRangeColor,
                        min: widget.min,
                        max: widget.max,
                        value: data,
                        onChanged: (lowerValue) {
                          log("message");
                          setState(() {
                            // _sliderValues![widget.bandId] = lowerValue;
                            EqualizerFlutter.setBandLevel(
                                widget.bandId, lowerValue.toInt());
                          });
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            '${widget.freq ~/ 1000} Hz',
            style: TextStyle(
                color: widget.enable
                    ? const Color.fromRGBO(255, 255, 255, 1)
                    : Colors.grey),
          ),
        ],
      ),
    );
  }
}

Shimmer homeScreenLoader(BuildContext context) {
  SizeConfig().init(context);

  return Shimmer.fromColors(
      baseColor: Colors.grey[600]!,
      highlightColor: const Color.fromRGBO(255, 255, 255, 0.1),
      child: Padding(
        padding: const EdgeInsets.only(right: 16, left: 16),
        child: Container(
          height: 100,
          width: double.infinity,
          decoration: const BoxDecoration(),
        ),
      ));
}
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
              //             toastMessage("${e.message}\n${e.details}",
              //                 Colors.black, Colors.white);
              //             const snackBar = SnackBar(
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