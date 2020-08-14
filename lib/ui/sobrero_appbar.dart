// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPG 3.0 license that can be
// found in the LICENSE file.

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import 'package:mySobrero/impostazioni.dart';
import 'package:mySobrero/localization/localization.dart';
import 'package:mySobrero/reapi3.dart';
import 'package:mySobrero/ui/helper.dart';

class SobreroAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size(double.infinity, 65);

  final double elevation;
  final double topCorrection;
  String profilePicUrl;
  UnifiedLoginStructure loginStructure;
  String session;
  Function(String url) setProfileCallback;

  SobreroAppBar({
    Key key,
    this.elevation = 0,
    this.topCorrection = 0,
    @required this.profilePicUrl,
    @required this.loginStructure,
    @required this.session,
    @required this.setProfileCallback
  }) :  assert(elevation != null),
        assert(elevation >= 0),
        assert(elevation <= 1),
        super(key: key);

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(elevation * 0.1),
          blurRadius: 10,
          spreadRadius: 10,
        ),
      ],
    ),
    child: SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20,3 - topCorrection,20,3 + topCorrection),
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                LineIcons.bars,
                color: Theme.of(context).primaryColor,
              ),
              //iconSize: 25,
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            Spacer(),
            Hero(
              tag: "main_logosobre",
              child: SizedBox(
                width: 30,
                height: 30,
                child: Image.asset('assets/images/logo_sobrero_grad.png'),
              ),
            ),
            Spacer(),
            IconButton(
              icon: Icon(
                LineIcons.gear,
                color: Theme.of(context).primaryColor,
              ),
              //iconSize: 25,
              onPressed: () => Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (a, b, c) => ImpostazioniView(
                    unifiedLoginStructure: loginStructure,
                    profileURL: profilePicUrl,
                    profileCallback: setProfileCallback,
                    session: session,
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
              ),
            ),
          ],
        ),
      ),
    ),
  );
}