import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musiq/src/app.dart';
import 'package:musiq/src/core/local/helper/object_box.dart';
import 'package:musiq/src/core/utils/my_http_overrides.dart';

// Object box instance
late ObjectBox objectbox;
late AudioHandler audioHandler;
Future<void> main() async {
  // This instance for handshaking error fix
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  // Audio player init
  // init();
  // Objectbox crearte
  objectbox = await ObjectBox.create();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationIcon: 'mipmap/ic',
    androidShowNotificationBadge: true,
    androidNotificationOngoing: true,
  );

  runApp(const MyApp());
}
