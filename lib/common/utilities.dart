import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

  static String formatArgumentString (String loc, {String arg, List<String>args}){
    if (args != null) {
      String _res = loc;
      int _i = 0;
      args.forEach((element) {
        _res = _res.replaceAll("\$$_i", element);
        _i++;
      });
      return _res;
    }
    if (arg != null)
      return loc.replaceAll("\$", arg);
    return null;
  }

  static bool get isInternalBuild {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }

  static bool initNotifications(){
    FlutterLocalNotificationsPlugin _lnP = FlutterLocalNotificationsPlugin();
    //TODO: impostare il drawable su Android
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: (i, s, ss, sss){
        return Future.value(true);
        },
    );
    var initializationSettings = InitializationSettings(
      initializationSettingsAndroid,
      initializationSettingsIOS,
    );

    _lnP.initialize(
      initializationSettings,
      onSelectNotification: (payload) async {
        if (payload != null) {
          debugPrint('notification payload: ' + payload);
        }
        },
    );
    return true;
  }

  static void sendNotification({
    @required String title,
    @required String body,
    String payload = "no_payload",
    String channelID = "it.edu.mysobrero.nc.debug",
    String channelName = "Notifiche di debug",
    String channelDesc = "Include le notifiche di debug di mySobrero",
  }){
    FlutterLocalNotificationsPlugin _lnP = FlutterLocalNotificationsPlugin();
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channelID, channelName, channelDesc,
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    _lnP.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}