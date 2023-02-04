import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:musiq/src/app.dart';
import 'package:musiq/src/local/helper/object_box.dart';
import 'package:musiq/src/utils/audio_player_handler.dart';
import 'package:musiq/src/utils/my_http_overrides.dart';

late ObjectBox objectbox;
late AudioHandler audioHandler;
Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  init();
  objectbox = await ObjectBox.create();
  runApp(const MyApp());
}
