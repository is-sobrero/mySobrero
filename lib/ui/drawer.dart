// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:mySobrero/ui/helper.dart';

class SobreroDrawer extends StatelessWidget {
  final List<Widget> children;
  final bool isPad;
  SobreroDrawer({
    Key key,
    @required this.children,
    this.isPad = false
  }) :  assert(children != null),
        super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
    child: SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          15,
          UIHelper.isPad(context) ? 10 : 0,
          15,
          15,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (UIHelper.isPad(context)) Padding(
                padding: EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/logo_sobrero_grad.png',
                  width: 40,
                  height: 40,
                ),
              ),
              ...children,
            ]
          ),
        )
      )
    ),
  );
}