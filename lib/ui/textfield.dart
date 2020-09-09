// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

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
