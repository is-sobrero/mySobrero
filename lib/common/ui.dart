// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:mySobrero/common/definitions.dart';

class AppColorScheme {
  static Color primaryColor = Color(0xFF0281EF);
  static Color secondaryColor = Color(0xFF0281EF);
  static Color scaffoldColor = Colors.white;
  static Color toggleColor = Colors.white;
  static Color darkScaffoldColor = Color(0xff000000);//Color(0xff121212);
  static Color darkCardColor = Color(0xff1c1c1c);//Color(0xff212121);
  static Color darkBottomNavColor = Color(0xff1c1c1c);//Color(0xff242424);
  static Color darkCanvasColor = Color(0xff000000); //Color(0xff242424);
  static Color sectionColor = Color(0xFFfafafa);
  static Color darkSectionColor = Color(0xFF212121);
  static Color darkToggleColor = Color(0xFF515151);
  static Color canvasColor = Color(0xFFEEEEEE);

  static List<Color> appGradient = [
    const Color(0xFF00C6FF),
    const Color(0xFF0360E7),
  ];

  static List<Color> greenGradient = [
    Color(0xFF38f9d7),
    Color(0xFF43e97b)
  ];

  static List<Color> yellowGradient = [
    Color(0xffFFD200),
    Color(0xffF7971E)
  ];

  static List<Color> redGradient = [
    Color(0xffFF416C),
    Color(0xffFF4B2B),
  ];

  static List<Color> blueGradient = [
    Color(0xff005C97),
    Color(0xff363795),
  ];
}

class HorizontalSectionList extends StatelessWidget {
  String sectionTitle;
  int itemCount;
  double height;
  HorizontalSectionListItemBuilder itemBuilder;

  HorizontalSectionList({
    Key key,
    @required this.sectionTitle,
    @required this.itemCount,
    @required this.height,
    @required this.itemBuilder
  }) :  assert(sectionTitle != null),
        assert(itemCount != null),
        assert(itemCount > 0),
        assert(height != null),
        assert(height > 0),
        assert(itemBuilder != null),
        super(key: key);

  @override
  Widget build (BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SafeArea(
          top: false,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              sectionTitle,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Container(
          height: height + 30,
          child: ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: itemCount,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, i) => itemBuilder(
              i == 0,
              i == itemCount -1,
              i,
            ),
          ),
        )
      ],
    );
  }
}
