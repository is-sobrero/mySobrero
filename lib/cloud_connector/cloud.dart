import 'dart:convert';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:mySobrero/common/definitions.dart';
import 'package:mySobrero/common/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:package_info/package_info.dart';

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
