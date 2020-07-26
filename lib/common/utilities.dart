import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

bool get isInternalBuild {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

String get getSystemPlatform {
  String systemPlatform = "webclient";
  if (!kIsWeb){
    systemPlatform = (Platform.isWindows ? "win32" : "") +
    (Platform.isAndroid ? "android" : "") +
    (Platform.isFuchsia ? "fuchsia" : "") +
    (Platform.isIOS ? "iOS" : "") +
    (Platform.isLinux ? "linux" : "") +
    (Platform.isMacOS ? "macos" : "");
  }
  return systemPlatform;
}

void openURL(BuildContext context, String url) async {
  try {
    await launch(
      url,
      option: new CustomTabsOption(
        toolbarColor: Theme.of(context).primaryColor,
        enableDefaultShare: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
        extraCustomTabs: <String>[
          'org.mozilla.firefox',
          'com.microsoft.emmx',
        ],
      ),
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}

class Utilities {
  static String getRandString(int len) {
    var random = Random.secure();
    var values = List<int>.generate(len, (i) =>  random.nextInt(255));
    return base64UrlEncode(values);
  }

  static String formatLocalized (String loc, String arg){
    return loc.replaceAll("\$", arg);
  }
}