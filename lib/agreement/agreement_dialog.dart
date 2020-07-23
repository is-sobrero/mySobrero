// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mySobrero/agreement/license.dart';
import 'package:mySobrero/common/sobreroicons.dart';
import 'package:mySobrero/common/ui.dart';

class AgreementScreen extends StatefulWidget {
  @override
  _AgreementState createState() => _AgreementState();
}

class _AgreementState extends State<AgreementScreen> {
  final ScrollController _controller = new ScrollController();
  var _end = false;

  _listener() {
    final maxScroll = _controller.position.maxScrollExtent;
    final minScroll = _controller.position.minScrollExtent;
    if (_controller.offset >= maxScroll) {
      setState(() {
        _end = true;
      });
    }

    if (_controller.offset <= minScroll) {
      setState(() {
        _end = false;
      });
    }
  }

  @override
  void initState() {
    _controller.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_listener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  SobreroIcons2.handshake,
                  color: Theme.of(context).primaryColor,
                  size: 35,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                  child: Text(
                    "Termini e Condizioni dell'App",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _controller,
                    child: Html(
                      data: licenseHTML,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: SobreroButton(
                    text: _end ? "Accetta i termini" : "Leggi i termini",
                    color: _end ? Theme.of(context).primaryColor : Color(0xFF555555),
                    suffixIcon: _end ? Icon(LineIcons.check) : Icon(LineIcons.ban),
                    onPressed: _end ? () => Navigator.pop(context) : null,
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
