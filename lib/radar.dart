// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPG 3.0 license that can be
// found in the LICENSE file.
import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import 'package:mySobrero/localization/localization.dart';
import 'package:mySobrero/reAPI/reapi.dart';
import 'package:mySobrero/ui/button.dart';
import 'package:mySobrero/ui/textfield.dart';
import 'package:package_info/package_info.dart';


class FileARadarView extends StatefulWidget {
  @override
  _RadarState createState() => _RadarState();
}

class _RadarState extends State<FileARadarView> {

  Future<String> _generateDebugData () async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    PackageInfo info = await PackageInfo.fromPlatform();
    String _vendor, _model, _os, _version;
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      _vendor = androidInfo.brand;
      _model = androidInfo.device;
      _os = "Android";
      _version = "SDK ${androidInfo.version.sdkInt}";
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      _vendor = "Apple";
      _model = iosInfo.utsname.machine;
      _os = "iOS";
      _version = iosInfo.systemVersion;
    }
    String _marksResponse = await reAPI4.instance.getData("GET_VOTI_LIST_DETAIL");
    String _noticesResponse = await reAPI4.instance.getData("GET_COMUNICAZIONI_MASTER");
    String _assignmentsResponse = await reAPI4.instance.getData("GET_COMPITI_MASTER");
    final Map<String, dynamic> _bugData = new Map<String, dynamic>();
    _bugData['device_vendor'] = _vendor;
    _bugData['device_model'] = _model;
    _bugData['device_os'] = _os;
    _bugData['device_version'] = _version;
    _bugData['mysobrero_versionMajor'] = info.version;
    _bugData['mysobrero_versionMinor'] = info.buildNumber;
    _bugData['marksResponse'] = _marksResponse;
    _bugData['noticesResponse'] = _noticesResponse;
    _bugData['assignmentResponse'] = _assignmentsResponse;
    print(jsonEncode(_bugData));
    return jsonEncode(_bugData);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                TablerIcons.bug,
                color: Theme.of(context).primaryColor,
                size: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                child: Text(
                  AppLocalizations.of(context).translate(
                    "RADAR_FILE_A",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context).translate(
                          "RADAR_DESC_FULL",
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SobreroTextField(
                        margin: EdgeInsets.only(top: 15, bottom: 10),
                        hintText: AppLocalizations.of(context).translate(
                          "RADAR_DESCRIBE_THE_PROBLEM",
                        ),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        height: 200,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(
                              TablerIcons.file_text,
                              color: Theme.of(context).primaryColor,
                              size: 30,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context).translate(
                                "RADAR_DATA_INCLUDED",
                              ),
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 12.5, left: 2.5),
                            child: Icon(
                              TablerIcons.device_mobile,
                              size: 25,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context).translate(
                                "RADAR_DATA_DEVICEID",
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 12.5, left: 2.5),
                            child: Icon(
                              TablerIcons.user,
                              size: 25,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context).translate(
                                "RADAR_DATA_STUDENTID",
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 12.5, left: 2.5),
                            child: Icon(
                              TablerIcons.database,
                              size: 25,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context).translate(
                                "RADAR_DATA_SESSION",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: SobreroButton(
                      margin: EdgeInsets.only(right: 5),
                      text: AppLocalizations.of(context).translate(
                        "RADAR_FILE_DO",
                      ),
                      color: Theme.of(context).primaryColor,
                      suffixIcon: Icon(
                        TablerIcons.check,
                      ),
                      onPressed: () => _generateDebugData(),
                    ),
                  ),
                  Flexible(
                    child: SobreroButton(
                      margin: EdgeInsets.only(left: 5),
                      text: AppLocalizations.of(context).translate(
                        "UNI_GO_BACK",
                      ),
                      color: Theme.of(context).primaryColor,
                      suffixIcon: Icon(
                        TablerIcons.arrow_back,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
