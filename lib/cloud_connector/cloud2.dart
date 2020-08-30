// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'dart:io';
import 'dart:convert';

import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mySobrero/sso/authentication_qr.dart';
import 'package:package_info/package_info.dart';

import 'package:mySobrero/cloud_connector/ConfigData.dart';
import 'package:mySobrero/cloud_connector/StringData.dart';
import 'package:mySobrero/common/definitions.dart';
import 'package:mySobrero/common/utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';

// TODO: implementare SSL pinning in tutto il CloudConnector

class CloudConnector {
  static String cloudEndpoint = "https://reapistaging.altervista.org/api/v3/";

  static Future<bool> registerSession({
    @required String uid,
    @required String name,
    @required String surname,
    @required String currentClass,
    @required String level,
    @required String course,
    @required String token,
  }) async {
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

    var response = await http.post(
      cloudEndpoint + "resolveAuthentication.php",
      body: {
        'token': token,
        'uid': uid,
        'name': name,
        'surname': surname,
        'class': currentClass,
        'lvl': level,
        'platform': systemPlatform,
        'course': course,
        'ver': kIsWeb ? "webclient" : info.buildNumber
      },
    );

    return response.statusCode == 200;
  }

  static Future<ConfigData> getServerConfig() async{
    var res = await http.get(cloudEndpoint + "getData.php?reference=config");
    return ConfigData.fromJson(jsonDecode(res.body));
  }

  static Future<String> getProfilePicture(String uid) async {
    var res = await http.get(
        cloudEndpoint + "getData.php?reference=profile&uid=$uid"
    );
    return StringData.fromJson(jsonDecode(res.body)).data;
  }

  static Future<Map<String, int>> getGoals({@required token}) async {
    var res = await http.get(
        cloudEndpoint + "getData.php?reference=goals&token=$token"
    );
    String data = StringData.fromJson(jsonDecode(res.body)).data;
    Map<String, int> tempReturn = new Map<String, int> ();
    if (data == null) return tempReturn;
    Map<String, dynamic> _tempObbiettivi = jsonDecode(data);
    _tempObbiettivi.forEach((key, value){
      tempReturn[key] = int.parse(value.toString());
    });
    return tempReturn;
  }

  static Future<List<AuthenticationQR>> getLogHistory({@required token}) async {
    /*var res = await http.get(
        cloudEndpoint + "getData.php?reference=goals&token=$token"
    );
    String data = StringData.fromJson(jsonDecode(res.body)).data;*/
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String data = _prefs.getString('loggedAuths');
    List<AuthenticationQR> tempReturn = new List<AuthenticationQR>();
    if (data == null) return tempReturn;
    List<dynamic> _tempLogs = jsonDecode(data);
    _tempLogs.forEach((value) =>
        tempReturn.add(AuthenticationQR.fromJson(value))
    );
    return tempReturn;
  }

  static Future<bool> authorizeApp({
    @required guid,
    @required token,
  }) async {
    var res = await http.get(
        cloudEndpoint + "authorize.php?&guid=$guid&token=$token"
    );
    return true;
  }

  static Future<RemoteNews> getRemoteHeadingNews() async {
    var res = await http.get(cloudEndpoint + "getData.php?reference=config");
    return RemoteNews.fromJson(jsonDecode(res.body)['data']);
  }

  static Future<bool> setLogHistory({
    AuthenticationQR item,
    @required token,
    Function(List<AuthenticationQR>) callback
  }) async {
    List<AuthenticationQR> _history = await getLogHistory(token: token);
    _history.add(item);
    if (_history.length > 25)
      _history = _history.sublist(
        _history.length - 25,
        _history.length - 1,
      );
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('loggedAuths', jsonEncode(_history));
    callback(_history);
    return true;

  }

  static Future<bool> setGoals({
    @required String token,
    @required String goals
  }) async {
    var response = await http.post(
      cloudEndpoint + "pushData.php",
      body: {
        'token': token,
        'data': goals,
        'reference': "goals",
      },
    );
    print("cloud goals ${response.statusCode}");

    return response.statusCode == 200;
  }

  static Future<bool> setProfilePicture({
    @required String token,
    @required File image
  }) async {
    var stream = http.ByteStream(DelegatingStream.typed(image.openRead()));
    var length = await image.length();

    var uri = Uri.parse(cloudEndpoint + "pushData.php");
    var request = new http.MultipartRequest("POST", uri);
    request.fields['token'] = token;
    request.fields['reference'] = 'profile';
    var multipartFile = new http.MultipartFile('avatar', stream, length,
        filename: token + Utilities.getRandString(20));

    request.files.add(multipartFile);
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });

    return response.statusCode == 200;
  }

}