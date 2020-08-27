// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:mySobrero/common/ui.dart';
import 'package:mySobrero/localization/localization.dart';
import 'package:mySobrero/login/login.dart';

import 'dart:async';
import 'dart:io';

import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;

StreamSubscription _sub;

Future<Null> initUniLinks() async {
  // Platform messages may fail, so we use a try/catch PlatformException.
  try {
    String initialLink = await getInitialLink();
    print("Schema da cold start");
    print(initialLink);
    // Parse the link and warn the user, if it is not correct,
    // but keep in mind it could be `null`.
  } on PlatformException {
    print("Schema da cold start");
    // Handle exception by warning the user their action did not succeed
    // return?
  }

  _sub = getLinksStream().listen((String link) {
    // Parse the link and warn the user, if it is not correct
    print("Schema da background");
    print(link);
  }, onError: (err) {
    print("Schema da background");
    // Handle exception by warning the user their action did not succeed
  });
}

void main() {
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  //timeDilation = 3.0;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
