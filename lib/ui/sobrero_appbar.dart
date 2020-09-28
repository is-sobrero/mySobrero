// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPG 3.0 license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class SobreroAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size(
      double.infinity,
      Platform.isMacOS ? 100 : 66
  );

  final double elevation;
  final double topCorrection;
  final GlobalKey refreshGlobalKey;
  final GlobalKey menuGlobalKey;
  final Function onRefresh;

  SobreroAppBar({
    Key key,
    this.elevation = 0,
    this.topCorrection = 0,
    @required this.refreshGlobalKey,
    @required this.menuGlobalKey,
    @required this.onRefresh,
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
        padding: EdgeInsets.fromLTRB(
          20,
          (Platform.isMacOS ? 47 : 3) - topCorrection,
          20,
          3 + topCorrection,
        ),
        child: Row(
          children: [
            IconButton(
              key: menuGlobalKey,
              icon: Icon(
                TablerIcons.menu,
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
                child: Image.asset('assets/images/logo_sobrero_grad1.png'),
              ),
            ),
            Spacer(),
            IconButton(
              key: refreshGlobalKey,
              icon: Icon(
                TablerIcons.refresh,
                color: Theme.of(context).primaryColor,
              ),
              //iconSize: 25,
              onPressed: onRefresh,
            ),
          ],
        ),
      ),
    ),
  );
}