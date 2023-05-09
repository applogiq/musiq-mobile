import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musiq/src/common_widgets/box/vertical_box.dart';
import 'package:musiq/src/core/constants/constant.dart';
import 'package:musiq/src/core/utils/size_config.dart';

class SleepTimerSheet extends StatefulWidget {
  const SleepTimerSheet({super.key, required this.player});
  final AudioPlayer player;

  @override
  State<SleepTimerSheet> createState() => _SleepTimerSheetState();
}

class _SleepTimerSheetState extends State<SleepTimerSheet> {
  List speedList = [
    "0.25x",
    "0.5x",
    "0.75x",
    "1.00x",
    "1.25x",
    "1.5x",
    "1.75x",
  ];
  // var intialIndex = 0;
  AudioPlayer player = AudioPlayer();
  final securetorage = const FlutterSecureStorage();
  final List _timeList = [0, 1, 2, 3, 4, 5];
  var _selectedSpeedIndex;
  Timer? sleepTimer;
  @override
  void initState() {
    super.initState();
    // initialMethod();
  }

  startSleepTimer(Duration duration, AudioPlayer player) {
    sleepTimer?.cancel();
    sleepTimer = Timer(duration, () {
      player.stop();
    });
  }

  // initialMethod() async {
  //   var raam = await securetorage.read(key: "speed");
  //   log("message${raam.toString()}");
  //   var initialvalue = int.tryParse(raam ?? "2");

  //   setState(() {
  //     _selectedSpeedIndex = initialvalue!;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
        stream: widget.player.speedStream,
        builder: (context, snapshot) {
          return Container(
            height: getProportionateScreenHeight(350),
            // color: const Color.fromRGBO(33, 33, 44, 1),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15), topLeft: Radius.circular(15)),
              color: Color.fromRGBO(33, 33, 44, 1),
            ),
            child: Column(
              children: [
                const VerticalBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Sleep timer",
                        style: fontWeight500(),
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.close))
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1,
                  height: 1,
                  color: Color.fromRGBO(255, 255, 255, 0.1),
                ),
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: _timeList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SpeedList(
                        speedText: '${_timeList[index]} minutes',
                        speedIndex: index,
                        onTap: () async {
                          setState(() {
                            _selectedSpeedIndex = index;
                            startSleepTimer(Duration(minutes: _timeList[index]),
                                widget.player);
                          });
                        },
                        isSelected: _selectedSpeedIndex == index,
                      );
                    },
                  ),
                )
              ],
            ),
          );
        });
  }
}

class SpeedList extends StatefulWidget {
  const SpeedList(
      {super.key,
      required this.speedText,
      required this.speedIndex,
      required this.onTap,
      required this.isSelected});
  final String speedText;
  final int speedIndex;
  final VoidCallback onTap;
  // final int initialindex;
  final bool isSelected;

  @override
  State<SpeedList> createState() => _SpeedListState();
}

class _SpeedListState extends State<SpeedList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: widget.onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.speedText,
              style: fontWeight500(
                  color: widget.isSelected
                      ? Colors.white
                      : const Color.fromRGBO(255, 255, 255, 0.5)),
            ),
            widget.isSelected ? const Icon(Icons.done) : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
