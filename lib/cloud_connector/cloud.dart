import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:mySobrero/common/definitions.dart';
import 'package:mySobrero/common/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:package_info/package_info.dart';

Future<int> getOnlineAppVersion() async {
  final RemoteConfig remoteConfig = await RemoteConfig.instance;
  await remoteConfig.fetch(expiration: const Duration(seconds: 0));
  await remoteConfig.activateFetched();
  final serverVersion = int.parse(remoteConfig.getString('verupdate_prompt'));
  return serverVersion;
}

Future<String> getProfilePicture({@required String userID}) async {
  final DocumentSnapshot dataRetrieve = await Firestore.instance.collection('utenti').document(userID).get();
  return dataRetrieve.data["profileImage"];
}

Future<void> saveAccountData({@required String userID, String classe, String name, String surname, String accountLevel}) async {
  PackageInfo info;
  if (!kIsWeb) info = await PackageInfo.fromPlatform();

  String systemPlatform = "webclient";
  if (!kIsWeb){
    systemPlatform = (Platform.isWindows ? "win32" : "") +
        (Platform.isAndroid ? "android" : "") +
        (Platform.isFuchsia ? "fuchsia" : "") +
        (Platform.isIOS ? "iOS" : "") +
        (Platform.isLinux ? "linux" : "") +
        (Platform.isMacOS ? "macos" : "");
  }

  Firestore.instance.collection('utenti').document(userID).setData({
    'classe': classe,
    'cognome': surname,
    'nome': name,
    'ultimo accesso': DateTime.now().toIso8601String(),
    'platform': systemPlatform,
    'build flavour': isInternalBuild ? 'internal' : 'production',
    'version' : kIsWeb ? "webclient" : info.buildNumber,
    'livelloAccount' : accountLevel
  }, merge: true);
}

void setAnalyticsData({@required String userID, String classe, String sezione, String corso, String surname, String accountLevel}) {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  if (!kIsWeb) {
    analytics.setUserId("UID$userID$surname");
    analytics.setUserProperty(name: "anno", value: classe);
    analytics.setUserProperty(name: "classe", value: "$classe $sezione");
    analytics.setUserProperty(name: "corso", value: corso);
    analytics.setUserProperty(name: "indirizzo", value: corso.contains("Liceo") ? "liceo" : "itis");
    analytics.setUserProperty(name: "platform", value: getSystemPlatform);
    analytics.setUserProperty(name: "livelloAccount", value: accountLevel);
  }
}

Future<RemoteNews> getRemoteHeadingNews() async {
  final RemoteConfig remoteConfig = await RemoteConfig.instance;
  await remoteConfig.fetch(expiration: const Duration(seconds: 0));
  await remoteConfig.activateFetched();
  final notice = jsonDecode(remoteConfig.getString('notice_setting'));
  return RemoteNews.fromJson(notice);
}