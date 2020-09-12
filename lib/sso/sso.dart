// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'dart:io' show Platform;

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:intl/intl.dart';
import 'package:mySobrero/sso/authorize.dart';
import 'package:mySobrero/sso/intent_page.dart';
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
  SSOProvider({@required this.session});

  @override
  _SSOProviderState createState() => _SSOProviderState();
}

class _SSOProviderState extends State<SSOProvider> {
  QRViewController _qrController;

  Future<List<AuthenticationQR>> _authentications;

  bool _isAuthorizing = false;

  @override
  void initState() {
    super.initState();
    _authentications = CloudConnector.getLogHistory(token: widget.session);
  }

  void closeDialog() {
    _qrController.resumeCamera();
    Navigator.of(context).pop();
    _isAuthorizing = false;
  }

  void authorizeApp(String data) async {
    if (_isAuthorizing) return;
    _isAuthorizing = true;
    _qrController.pauseCamera();
    AuthenticationQR _req = SSOAuthorize.getDetails(
      data: data,
    );
    if (_req == null) {
      showDialog(
        context: context,
        builder: (context) => SobreroDialogSingle(
          headingWidget: Icon(
            TablerIcons.qrcode,
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
      return;
    }
    await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => SSOIntentPage(
          request: _req,
          session: widget.session,
        ),
        transitionDuration: Duration(
          milliseconds: UIHelper.pageAnimDuration,
        ),
        transitionsBuilder: (_, p, s, c) => SharedAxisTransition(
          animation: p,
          secondaryAnimation: s,
          transitionType: SharedAxisTransitionType.scaled,
          child: c,
        ),
      ),
    );
    _isAuthorizing = false;
    _qrController.resumeCamera();
  }

  int _currentPage = 0;

  @override
  void dispose() {
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
                    //controller.resumeCamera();
                  }),
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
          ),
        ],
      );

  Widget historyView() {
    return FutureBuilder<List<AuthenticationQR>>(
      key: ValueKey<int>(11),
      future: _authentications,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return SobreroLoading(
              loadingStringKey: "loadingLogs",
            );
          case ConnectionState.done:
            if (snapshot.hasError)
              return SobreroError(
                snapshotError: snapshot.error,
              );
            return Column(
              children: [
                if (snapshot.data.length == 0)
                  SobreroEmptyState(
                    emptyStateKey: "ssoNoHistory",
                  ),
                if (snapshot.data.length > 0)
                  ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, i) {
                        DateTime timestamp =
                            DateTime.fromMillisecondsSinceEpoch(
                                    snapshot.data[i].timestamp * 1000,
                                    isUtc: true)
                                .toLocal();
                        final day = DateFormat.MMMMd(Platform.localeName)
                            .format(timestamp);
                        final time = DateFormat('HH:mm').format(timestamp);
                        return SobreroFlatTile(
                          margin: EdgeInsets.only(bottom: 15),
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    snapshot.data[i].domain,
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    softWrap: false,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          Text(day),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 3),
                                            child: Icon(
                                              TablerIcons.calendar,
                                              size: 18,
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(time),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 3),
                                            child: Icon(
                                              TablerIcons.clock,
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
                                    TablerIcons.device_laptop,
                                    size: 20,
                                  ),
                                ),
                                Text(snapshot.data[i].clientIp),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Image.asset(
                                  'icons/flags/png/${snapshot.data[i].clientCountry.toLowerCase()}.png',
                                  package: 'country_icons',
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(snapshot.data[i].clientCity),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                Container(
                  width: double.infinity,
                )
              ],
            );
        }
        return null;
      },
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
              AppLocalizations.of(context).translate("scan"),
              AppLocalizations.of(context).translate("loginHistory"),
            ],
            width: 300,
            selectedItem: _currentPage,
            onToggleCallback: (s) => setState(() {
              _currentPage = s;
            }),
          ),
          PageTransitionSwitcher2(
            reverse: _currentPage == 0,
            layoutBuilder: (_entries) => Stack(
              children:
                  _entries.map<Widget>((entry) => entry.transition).toList(),
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
            child: _currentPage == 0 ? scanView() : historyView(),
          )
        ],
      ),
    );
  }
}
