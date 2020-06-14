import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

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