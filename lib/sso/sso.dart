// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io' show Platform;

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mySobrero/ui/helper.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:mySobrero/sso/authentication_qr.dart';
import 'package:mySobrero/ui/data_ui.dart';
import 'package:mySobrero/ui/detail_view.dart';
import 'package:mySobrero/ui/dialogs.dart';
import 'package:mySobrero/ui/toggle.dart';
import 'package:mySobrero/cloud_connector/cloud2.dart';
import 'package:mySobrero/common/pageswitcher.dart';
import 'package:mySobrero/localization/localization.dart';
import 'package:mySobrero/common/tiles.dart';

// TODO: sincronizzare accessi con il cloud

class SSOProvider extends StatefulWidget {
  String session;
  SSOProvider ({
    @required this.session
  });

  @override
  _SSOProviderState createState() => _SSOProviderState();
}

class _SSOProviderState extends State<SSOProvider> {

  QRViewController _qrController;

  List<AuthenticationQR> _loggedAuths = List<AuthenticationQR>();

  @override
  void initState(){
    super.initState();
    CloudConnector.getLogHistory(token: widget.session).then(
          (list) => _loggedAuths = list,
    );
  }

  void closeDialog(){
    _qrController.resumeCamera();
    Navigator.of(context).pop();
  }

  void authorizeApp(String data){
    AuthenticationQR _req;
    _qrController.pauseCamera();
    try {
      var json = jsonDecode(data);
      _req = AuthenticationQR.fromJson(json);
      showDialog(
        context: context,
        builder: (context) => SobreroDialogAbort(
          headingWidget: Icon(
            LineIcons.unlock_alt,
            size: 40,
            color: Colors.green,
          ),
          title: AppLocalizations.of(context).translate("askAuthorize"),
          okButtonText: AppLocalizations.of(context).translate("authorize"),
          abortButtonText: AppLocalizations.of(context).translate("denyAccess"),
          okButtonCallback: () {
            CloudConnector.authorizeApp(
              guid: _req.session,
              token: widget.session,
            );
            Navigator.of(context).pop();
            showDialog(
              context: context,
              builder: (context) => SobreroDialogSingle(
                headingWidget: Icon(
                  LineIcons.check,
                  size: 40,
                  color: Colors.green,
                ),
                title: AppLocalizations.of(context).translate("ssoAuthorized"),
                buttonText: "Ok",
                buttonCallback: () {
                  CloudConnector.setLogHistory(
                    token: widget.session,
                    callback: (list) => setState((){
                      _loggedAuths = list;
                    }),
                    item: _req,
                  );
                  closeDialog();
                },
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        AppLocalizations.of(context).translate("ssoSuccess"),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          abortButtonCallback: () {
            Navigator.of(context).pop();
            _qrController.resumeCamera();
          },
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Manrope',
                    ),
                    children: [
                      TextSpan(
                        text: AppLocalizations.of(context)
                            .translate("ssoDialog1"),
                      ),
                      TextSpan(
                          text: _req.domain,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )
                      ),
                      TextSpan(
                        text: AppLocalizations.of(context)
                            .translate("ssoDialog2"),
                      ),
                      TextSpan(
                          text: AppLocalizations.of(context)
                              .translate("ipAddress"),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )
                      ),
                      TextSpan(
                        text: _req.clientIp,
                      ),
                      TextSpan(
                          text: AppLocalizations.of(context)
                              .translate("location"),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Image.asset(
                            'icons/flags/png/${_req.clientCountry.toLowerCase()}.png',
                            package: 'country_icons',
                            height: 15,
                          ),
                        ),
                      ),
                      TextSpan(
                        text: _req.clientCity,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                child: Text(
                  AppLocalizations.of(context).translate("ssoSharedData"),
                ),
              )
            ],
          ),
        ),
      );
    } on FormatException catch (e){
      showDialog(
        context: context,
        builder: (context) => SobreroDialogSingle(
          headingWidget: Icon(
            LineIcons.qrcode,
            size: 40,
            color: Colors.red,
          ),
          title: AppLocalizations.of(context).translate("ssoNotAuthorized"),
          buttonText: "Ok",
          buttonCallback: closeDialog,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  AppLocalizations.of(context).translate("ssoInvalidRequest"),
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  int _currentPage = 0;
  
  @override
  void dispose(){
    _qrController?.dispose();
    super.dispose();
  }

  Widget scanView() => Column(
    key: ValueKey<int>(10),
    children: [
      SizedBox(
        width: 1,
        height: 20,
      ),
      ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: 300,
          height: 300,
          child: QRView(
              key: GlobalKey(debugLabel: 'QR'),
              overlay: QrScannerOverlayShape(
                borderColor: Theme.of(context).primaryColor,
                borderRadius: 15,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 200,
              ),
              onQRViewCreated: (QRViewController controller) {
                this._qrController = controller;
                controller.scannedDataStream.listen((scanData) {
                  authorizeApp(scanData);
                });
                controller.resumeCamera();
              }
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(15),
        child: Text(
          AppLocalizations.of(context).translate("ssoPointQR"),
          textAlign: TextAlign.center,
        ),
      ),
      Container(
        width: double.infinity,
      )
    ],
  );

  Widget historyView() {
    return Column(
      key: ValueKey<int>(11),
      children: [
        if (_loggedAuths.length == 0) SobreroEmptyState(
          emptyStateKey: "ssoNoHistory",
        ),
        if (_loggedAuths.length > 0) ListView.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: _loggedAuths.length,
          itemBuilder: (_, i) {
            DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(
              _loggedAuths[i].timestamp * 1000,
              isUtc: true
            ).toLocal();
            final day = DateFormat.MMMMd(Platform.localeName).format(timestamp);
            final time = DateFormat('HH:mm').format(timestamp);
            return SobreroFlatTile(
              margin: EdgeInsets.only(bottom: 15),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _loggedAuths[i].domain,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    //Spacer(),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: <Widget>[
                              Text(day),
                              Padding(
                                padding: const EdgeInsets.only(left: 3),
                                child: Icon(
                                  LineIcons.calendar_o,
                                  size: 18,
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(time),
                              Padding(
                                padding: const EdgeInsets.only(left: 3),
                                child: Icon(
                                  LineIcons.clock_o,
                                  size: 18,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        LineIcons.laptop,
                        size: 20,
                      ),
                    ),
                    Text(_loggedAuths[i].clientIp),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Image.asset(
                      'icons/flags/png/${_loggedAuths[i].clientCountry.toLowerCase()}.png',
                      package: 'country_icons',
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(_loggedAuths[i].clientCity),
                    ),
                  ],
                ),
              ],
            );
          }
        ),
        Container(
          width: double.infinity,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SobreroDetailView(
      title: AppLocalizations.of(context).translate("authorizeApp"),
      child: Column(
        children: [
          SobreroToggle(
            margin: EdgeInsets.only(top: 10, bottom: 15),
            values: [
              AppLocalizations.of(context).translate("loginHistory"),
              AppLocalizations.of(context).translate("scan"),
            ],
            width: 300,
            selectedItem: _currentPage,
            onToggleCallback: (s) => setState((){
              _currentPage = s;
            }),
          ),
          PageTransitionSwitcher2(
            reverse: _currentPage == 0,
            layoutBuilder: (_entries) => Stack(
              children: _entries
                  .map<Widget>((entry) => entry.transition)
                  .toList(),
              alignment: Alignment.topLeft,
            ),
            duration: Duration(milliseconds: UIHelper.pageAnimDuration),
            transitionBuilder: (c, p, s) => SharedAxisTransition(
              fillColor: Colors.transparent,
              animation: p,
              secondaryAnimation: s,
              transitionType: SharedAxisTransitionType.horizontal,
              child: c,
            ),
            child: _currentPage == 1 ? scanView() : historyView(),
          )
        ],
      ),
    );
  }
}