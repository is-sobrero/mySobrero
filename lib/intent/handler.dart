// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:mySobrero/intent/intent.dart';
import 'package:mySobrero/reAPI/reapi.dart';
import 'package:mySobrero/sso/authentication_qr.dart';
import 'package:mySobrero/sso/authorize.dart';
import 'package:mySobrero/sso/intent_page.dart';
import 'package:mySobrero/ui/helper.dart';

class IntentHandler {
  BuildContext context;

  IntentHandler ({
    @required this.context,
  });

  void handle(String uri){
    String method = UriIntent.getMethodName(uri);
    String arg = UriIntent.getArgument(uri, method);
    if (UriIntent.isInvokingMethod(uri) &&
        UriIntent.isMethodSupported(uri) &&
        UriIntent.getArgument(uri, method) != null)
      switch (method){
        case "idp":
          print("IdP Richiesto, inizio convalida");
          var reqBytes = base64Decode(arg);
          var str = String.fromCharCodes(reqBytes);
          print(reqBytes);
          print(str);
          AuthenticationQR _req = SSOAuthorize.getDetails(data: str);
          if (_req != null){
            print("Richiesta valida");
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___)  => SSOIntentPage(
                  request: _req,
                  session: reAPI4.instance.getSession(),
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
          }
          break;
        default:
          print("?");
          break;
      }
    else
      print("Metodo non supportato / corrotto");
  }

}