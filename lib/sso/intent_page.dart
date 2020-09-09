// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:animations/animations.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:line_icons/line_icons.dart';

import 'package:mySobrero/cloud_connector/cloud2.dart';
import 'package:mySobrero/common/pageswitcher.dart';
import 'package:mySobrero/localization/localization.dart';
import 'package:mySobrero/sso/authentication_qr.dart';
import 'package:mySobrero/ui/button.dart';
import 'package:mySobrero/ui/helper.dart';

class SSOIntentType {
  static int backgroundStart = 0;
  static int coldStart = 1;
  static int qrCode = 2;
}

class SSOIntentPage extends StatefulWidget {
  AuthenticationQR request;
  String session;

  SSOIntentPage({
    @required this.request,
    @required this.session
  }) : assert(request != null);

  @override
  _SSOIntentPageState createState() => _SSOIntentPageState();
}

class _SSOIntentPageState extends State<SSOIntentPage>{
  bool _hasBeenAuthorized = false;

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: "main_logosobre",
                      child: Image.asset(
                        "assets/images/logo_sobrero_grad1.png",
                        width: 35,
                        height: 35,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 20,
                      color: Colors.grey,
                      margin: EdgeInsets.only(left: 10, right: 8),
                    ),
                    Icon(
                      LineIcons.unlock_alt,
                      color: Color(0xff00CA71),
                      size: 35,
                    ),
                  ],
                ),
                if(!_hasBeenAuthorized) Text(
                  AppLocalizations.of(context).translate("askAuthorize"),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                Expanded(
                  child: PageTransitionSwitcher2(
                    reverse: false,
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
                    child: _hasBeenAuthorized
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      key: ValueKey<int>(102),
                      children: [
                        SizedBox(width: double.infinity),
                        Container(
                          width: 200,
                          height: 200,
                          child: FlareActor(
                            "assets/animations/success.flr",
                            alignment: Alignment.center,
                            fit:BoxFit.contain,
                            animation: "root",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Applicazione autorizzata con successo",
                            style: TextStyle(
                              color: Color(0xff00CA71),
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )
                        : SingleChildScrollView(
                      key: ValueKey<int>(103),
                      child: Column(
                        children: [
                          RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyText1,
                              children: [
                                TextSpan(
                                  text: AppLocalizations.of(context)
                                      .translate("ssoDialog1"),
                                ),
                                TextSpan(
                                    text: widget.request.domain,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )
                                ),
                                TextSpan(
                                  text: AppLocalizations.of(context)
                                      .translate("ssoDialog2"),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 200,
                            margin: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  //spreadRadius: 10
                                )
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: FlutterMap(
                                options: MapOptions(
                                  center: LatLng(
                                    double.parse(widget.request.clientLat),
                                    double.parse(widget.request.clientLog),
                                  ),
                                  zoom: 13.0,
                                ),
                                layers: [
                                  TileLayerOptions(
                                      urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                      subdomains: ['a', 'b', 'c']
                                  ),
                                  MarkerLayerOptions(
                                    markers: [
                                      Marker(
                                        width: 40.0,
                                        height: 40.0,
                                        point: LatLng(
                                          double.parse(widget.request.clientLat),
                                          double.parse(widget.request.clientLog),
                                        ),
                                        builder: (ctx) => Image.asset(
                                          "assets/images/pin.png",
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15, right: 15, bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: Icon(LineIcons.laptop),
                                ),
                                Text(widget.request.clientIp),
                                Spacer(),
                                Text(widget.request.clientCity),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Image.asset(
                                    'icons/flags/png/${widget.request.clientCountry.toLowerCase()}.png',
                                    package: 'country_icons',
                                    height: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context).translate("ssoSharedData"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (!_hasBeenAuthorized) Column(
                  children: [
                    SobreroButton(
                        margin: EdgeInsets.only(top: 15.0),
                        text: AppLocalizations.of(context).translate("authorize"),
                        color: Color(0xff00CA71),
                        suffixIcon: Icon(LineIcons.unlock_alt),
                        onPressed: () {
                          CloudConnector.authorizeApp(
                            guid: widget.request.session,
                            token: widget.session,
                          );
                          CloudConnector.setLogHistory(
                              token: widget.session,
                              callback: (_) {},
                              item: widget.request
                          );
                          setState(() {
                            _hasBeenAuthorized = true;
                          });
                        }
                    ),
                    SobreroButton(
                      margin: EdgeInsets.only(top: 5.0),
                      text: AppLocalizations.of(context).translate("denyAccess"),
                      color: Colors.red,
                      suffixIcon: Icon(LineIcons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                if (_hasBeenAuthorized) SobreroButton(
                  margin: EdgeInsets.only(top: 5.0),
                  text: "Ritorna alla home",
                  color: Theme.of(context).primaryColor,
                  suffixIcon: Icon(LineIcons.home),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}