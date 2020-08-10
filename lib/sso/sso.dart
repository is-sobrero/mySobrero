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
import 'package:qrcode/qrcode.dart';

class SSOProvider extends StatefulWidget {
  @override
  _SSOProviderState createState() => _SSOProviderState();
}

class _SSOProviderState extends State<SSOProvider> {

  final _controller = TextEditingController();

  QRCaptureController _QRcontroller = QRCaptureController();


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
          QRCaptureView(controller: _QRcontroller),
          SobreroButton(
            text: "Autorizza con tkn",
            color: Theme.of(context).primaryColor,
            onPressed: (){
              AuthenticationQR _req;
              try {
                var json = jsonDecode(_controller.text);
                 _req = AuthenticationQR.fromJson(json);
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Stai tentando di autenticarti su ",
                                ),
                                TextSpan(
                                    text: _req.domain,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )
                                ),
                                TextSpan(
                                  text: " con il tuo account mySobrero, "
                                      "assicurati dell'attendibilità prima di "
                                      "autorizzare l'accesso.",
                                ),
                              ],
                            ),
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "Indirizzo IP: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )
                              ),
                              TextSpan(
                                text: _req.clientIp,
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "Località: ",
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
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                          child: Text(
                            "Verranno condivisi i tuoi dati anagrafici, la tua "
                                "classe e il tuo numero di matricola. La tua "
                                "password non verrà condivisa.",
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
                    title: "Accesso non autorizzato",
                    buttonText: "Ok",
                    buttonCallback: () => Navigator.of(context).pop(),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            "L'applicazione da autenticare ha generato una "
                                "richesta non valida, per preservare la tua "
                                "sicurezza il login è stato bloccato.",
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}