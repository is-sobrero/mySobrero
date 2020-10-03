// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:mySobrero/common/utilities.dart';
import 'package:mySobrero/localization/localization.dart';
import 'package:mySobrero/reAPI/reapi.dart';
import 'package:mySobrero/ui/button.dart';
import 'package:mySobrero/ui/data_ui.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'dart:async';

class Covid19Policy extends StatefulWidget {
  @override
  _Covid19PolicyState createState() => _Covid19PolicyState();
}

class _Covid19PolicyState extends State<Covid19Policy> {
  int _remainingSecs = 5;
  Timer _timer;

  Future<PdfController> _fetchPolicy() async {
    final response = await http.get(
      reAPI4.instance.getStartupCache().covid19info.fam_url,
    );
    return PdfController(
        document: PdfDocument.openData(response.bodyBytes),
    );
  }

  Future<PdfController> _policyFuture;

  @override
  void initState (){
    super.initState();
    _policyFuture = _fetchPolicy();
  }

  _acceptPolicy(){
    reAPI4.instance.acceptCovid19Informative();
    reAPI4.instance.updateCovid19InfoCache();
    Navigator.of(context).pop();
    setState((){});
  }

  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  "assets/images/covid_alert.png",
                  width: 35,
                  height: 35,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                  child: Text(
                    AppLocalizations.of(context).translate(
                      "COVID19_POLICY_TITLE",
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  AppLocalizations.of(context).translate(
                    "COVID19_POLICY_READ_CAREFULLY",
                  ),
                  textAlign: TextAlign.center,
                ),
                FutureBuilder<PdfController>(
                  future: _policyFuture,
                  builder: (context, snapshot){
                    switch (snapshot.connectionState){
                      case ConnectionState.none:
                      case ConnectionState.active:
                      case ConnectionState.waiting:
                        return SobreroLoading(
                          loadingStringKey: "COVID19_LOADING_POLICY",
                        );
                      case ConnectionState.done:
                        if (snapshot.hasError)
                          return SobreroError(
                            snapshotError: snapshot.error,
                          );

                        if (_timer == null) {
                          _remainingSecs = 5;
                          _timer = new Timer.periodic(
                              Duration(seconds: 1),
                                  (timer) {
                                setState((){
                                  _remainingSecs--;
                                });
                                if (_remainingSecs == 0) timer.cancel();
                              });
                        }
                        return Expanded(
                          child: PdfView(
                            controller: snapshot.data,
                          ),
                        );
                    }
                    return null;
                  },
                ),
                Text(
                  AppLocalizations.of(context).translate(
                    "COVID19_POLICY_TERMS",
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: SobreroButton(
                    text: _remainingSecs == 0
                        ? AppLocalizations.of(context).translate(
                          "COVID19_ACCEPT_POLICY",
                        )
                        : Utilities.formatArgumentString(
                            AppLocalizations.of(context).translate(
                              "COVID19_WAIT_SECONDS",
                            ),
                            args: [
                              _remainingSecs.toString(),
                              AppLocalizations.of(context).translate(
                                _remainingSecs == 1
                                    ? "COVID19_SINGULAR"
                                    : "COVID19_PLURAL",
                              ),
                            ],
                        ),
                    color: _remainingSecs == 0
                        ? Theme.of(context).primaryColor
                        : Color(0xFF555555)
                    ,
                    suffixIcon: Icon(
                      _remainingSecs == 0
                          ? TablerIcons.check
                          : TablerIcons.ban,
                    ),
                    onPressed: () => _remainingSecs == 0
                        ? _acceptPolicy()
                        : null,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}