// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:mySobrero/common/definitions.dart';
import 'package:mySobrero/custom/dropdown.dart';

class AppColorScheme {
  static Color primaryColor = Color(0xFF0360e7);
  static Color secondaryColor = Color(0xFF0360e7);
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
    const Color(0xFF0287d1),
    const Color(0xFF0335ff),
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

class SobreroTextField extends StatelessWidget {
  EdgeInsets margin;
  bool obscureText;
  Widget suffixIcon;
  String hintText;
  TextEditingController controller;

  SobreroTextField({
    Key key,
    this.margin = EdgeInsets.zero,
    this.obscureText = false,
    this.suffixIcon,
    this.controller,
    this.hintText,
  }) :  assert(margin != null),
        assert(obscureText != null),
        super(key: key);

  @override
  Widget build (BuildContext context){
    return Container(
      alignment: Alignment.centerLeft,
      margin: margin,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withAlpha(12),
            blurRadius: 10,
            spreadRadius: 10,
          ),
        ],
      ),
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
          isDense: false,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          suffixIcon: suffixIcon,
          hintText: hintText,
        ),
      ),
    );
  }
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

class SobreroDropdown extends StatelessWidget {
  String value;
  List<Widget> items;
  String hint;
  Function(String) onChanged;
  EdgeInsets margin;

  SobreroDropdown({
    Key key,
    @required this.value,
    @required this.items,
    this.margin = EdgeInsets.zero,
    this.hint = "",
    this.onChanged,
  }) :  assert(value != null),
        assert(items != null),
        assert(margin != null),
        assert(hint != null),
        super(key: key);

  @override
  Widget build(BuildContext context){
    return Center(
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withAlpha(12),
              blurRadius: 10,
              spreadRadius: 10,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: CustomDropdownButtonHideUnderline(
            child: Container(
              child: ButtonTheme(
                alignedDropdown: true,
                child: CustomDropdownButton<String>(
                  radius: 15,
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Icon(
                        Icons.unfold_more,
                        color: Theme.of(context).primaryColor
                    ),
                  ),
                  isExpanded: true,
                  hint: Text(
                    hint,
                    overflow: TextOverflow.ellipsis,
                  ),
                  value: value,
                  onChanged: onChanged,
                  items: items,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

