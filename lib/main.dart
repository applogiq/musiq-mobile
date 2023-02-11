import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:musiq/src/app.dart';
import 'package:musiq/src/core/local/helper/object_box.dart';
import 'package:musiq/src/core/utils/my_http_overrides.dart';

// Object box instance
late ObjectBox objectbox;

Future<void> main() async {
  // This instance for handshaking error fix
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  // Audio player init
  // init();
  // Objectbox crearte
  objectbox = await ObjectBox.create();

  runApp(const MyApp());
}
