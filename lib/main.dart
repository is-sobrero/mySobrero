import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:mySobrero/login/login.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:mySobrero/common/ui.dart';

void main() {
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  timeDilation = 3.0;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'mySobrero',
      theme: ThemeData(
        primaryColor: AppColorScheme().primaryColor,
        accentColor: AppColorScheme().secondaryColor,
        scaffoldBackgroundColor: AppColorScheme().scaffoldColor,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColorScheme().primaryColor,
        accentColor: AppColorScheme().secondaryColor,
        scaffoldBackgroundColor: AppColorScheme().darkScaffoldColor,
        backgroundColor: Colors.blue,
        cardColor: AppColorScheme().darkCardColor,
        bottomAppBarColor: AppColorScheme().darkBottomNavColor,
        canvasColor: AppColorScheme().darkCanvasColor,
      ),
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Theme.of(context).brightness
        ),
        child: Scaffold(
            body: AppLogin()
        ),
      ),
    );
  }
}
