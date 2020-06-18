// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/material.dart';

class AppColorScheme {
  final Color primaryColor = Color(0xFF0360e7);
  final Color secondaryColor = Color(0xFF0360e7);
  final Color scaffoldColor = Colors.white;
  final Color darkScaffoldColor = Color(0xff121212);
  final Color darkCardColor = Color(0xff212121);
  final Color darkBottomNavColor = Color(0xff242424);
  final Color darkCanvasColor = Color(0xff242424);
  final Color sectionColor = Color(0xFFfafafa);
  final Color darkSectionColor = Color(0xFF212121);

  List<Color> appGradient = [
    const Color(0xFF0287d1),
    const Color(0xFF0335ff),
  ];
}

class MainViewSimpleContainer extends StatelessWidget {
  MainViewSimpleContainer({
    Key key,
    @required this.title,
    @required this.children,
  }) :  assert(title != null),
        assert(children != null),
        super(key: key);

  String title;
  List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                  ),
                ),
              ),
              ...children,
            ],
          ),
        )
      ),
    );
  }
}

class UIHelper {
  BuildContext context;

  UIHelper({
    @required this.context,
  }) : assert(context != null);

  bool get isWide => MediaQuery.of(context).size.width > 500;

  int get columnCount {
    int columnCount = MediaQuery.of(context).size.width > 550 ? 2 : 1;
    columnCount = MediaQuery.of(context).size.width > 900 ? 3 : columnCount;
    return columnCount;
  }
}