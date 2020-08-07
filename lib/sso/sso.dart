// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import 'package:mySobrero/sso/authentication_qr.dart';
import 'package:mySobrero/ui/button.dart';
import 'package:mySobrero/ui/detail_view.dart';
import 'package:mySobrero/ui/dialogs.dart';
import 'package:mySobrero/ui/toggle.dart';

class SSOProvider extends StatefulWidget {
  @override
  _SSOProviderState createState() => _SSOProviderState();
}

class _SSOProviderState extends State<SSOProvider> {

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SobreroDetailView(
      title: "Autorizza app",
      child: Column(
        children: [
          SobreroToggle(
            margin: EdgeInsets.only(top: 10),
            values: [
              'Scansione',
              'Accessi recenti'
            ],
            width: 300,
            selectedItem: 0,
            onToggleCallback: (s) {},
          ),
          TextField(
            controller: _controller,
          ),
          SobreroButton(
            text: "Autorizza con tkn",
            color: Theme.of(context).primaryColor,
            onPressed: (){
              var json = jsonDecode(_controller.text);
              AuthenticationQR _req = AuthenticationQR.fromJson(json);
              showDialog(
                context: context,
                builder: (context) => SobreroDialogAbort(
                  headingWidget: Icon(
                    LineIcons.unlock_alt,
                    size: 40,
                    color: Colors.green,
                  ),
                  title: "Autorizzare l'accesso?",
                  okButtonText: "Autorizza",
                  abortButtonText: "Nega",
                  okButtonCallback: () => Navigator.of(context).pop(),
                  abortButtonCallback: () => Navigator.of(context).pop(),
                  content: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          "Stai tentando di autenticarti su ${_req.domain} "
                              "con il tuo account mySobrero, assicurati dell'"
                              "attendibilità prima di autorizzare l'accesso.",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text("IP: ${_req.clientIp}"),
                      Text("Località: ${_req.clientCity}"),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                        child: Text(
                          "Verranno condivisi i tuoi dati anagrafici, la tua "
                              "classe e il tuo numero di matricola",
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}