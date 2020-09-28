// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:mySobrero/common/ui.dart';
import 'package:mySobrero/common/utilities.dart';
import 'package:mySobrero/localization/localization.dart';
import 'package:mySobrero/login/login.dart';


void backgroundFetchHeadlessTask(String taskId) async {
  print('[BackgroundFetch] Headless event received.');
  BackgroundFetch.finish(taskId);
}

void main() {
  /// Togliere il commento in caso di debug delle animazioni
  //timeDilation = 3.0;
  WidgetsFlutterBinding.ensureInitialized();
  Utilities.initNotifications();
  runApp(MyApp());
  BackgroundFetch.registerHeadlessTask(
    backgroundFetchHeadlessTask,
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: [
        Locale('en', 'US'),
        Locale('it', 'IT'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      title: 'mySobrero',
      theme: ThemeData(
        primaryColor: AppColorScheme.primaryColor,
        accentColor: AppColorScheme.secondaryColor,
        scaffoldBackgroundColor: AppColorScheme.scaffoldColor,
        toggleableActiveColor: AppColorScheme.toggleColor,
        canvasColor: AppColorScheme.canvasColor,
        fontFamily: "Manrope",
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColorScheme.primaryColor,
        accentColor: AppColorScheme.secondaryColor,
        scaffoldBackgroundColor: AppColorScheme.darkScaffoldColor,
        backgroundColor: Colors.blue,
        cardColor: AppColorScheme.darkCardColor,
        bottomAppBarColor: AppColorScheme.darkBottomNavColor,
        canvasColor: AppColorScheme.darkCanvasColor,
        toggleableActiveColor: AppColorScheme.darkToggleColor,
        fontFamily: "Manrope",
      ),
      home: AppLogin(),
    );
  }
}
