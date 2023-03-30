import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musiq/src/core/routing/route.dart';
import 'package:musiq/src/core/routing/route_name.dart';
import 'package:provider/provider.dart';

import 'core/config/theme.dart';
import 'core/provider_list.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  AppLifecycleState? _appLifecycleState;
  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _appLifecycleState = state;
    });
    if (state == AppLifecycleState.paused) {
      player.pause();

      // App is being paused (e.g. switched to another app)
      // Do any necessary cleanup operations here
    } else if (state == AppLifecycleState.resumed) {
      // App is being resumed (e.g. user returns to the app)
      // Re-initialize any necessary resources here
    } else {
      player.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      // Provider initialization
      providers: providersList,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeData(context),
          initialRoute: RouteName.splash,
          onGenerateRoute: generateRoute,
        );
      },
    );
  }
}
