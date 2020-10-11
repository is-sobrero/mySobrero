// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class UIHelper {
  static bool isWide(context) {
    if (isPad(context))
      return MediaQuery.of(context).size.width > 900;
    return MediaQuery.of(context).size.width > 550;
  }

  static bool isPad(context) => MediaQuery.of(context).size.width > 900;

  static int columnCount (context, {double tileWidth: -1}) {
    if (tileWidth > 0) {
      double _precisionSize = (MediaQuery.of(context).size.width - 30) / tileWidth;
      print( _precisionSize);
      return _precisionSize.floor();
    }
    int columnCount = MediaQuery.of(context).size.width > 550 ? 2 : 1;
    columnCount = MediaQuery.of(context).size.width > 1080 ? 3 : columnCount;

    return columnCount;
  }

  static Color textColorByBackground (Color color) =>
      color.computeLuminance() > 0.45 ? Colors.black : Colors.white;

  static int pageAnimDuration = 400;

  static String upperCaseFirst(String s) {
    String builder = "";
    s.split(" ").toList().forEach((sez){
      String temp = (sez??'').length<1 ? '' : sez[0].toUpperCase() + sez.substring(1).toLowerCase();
      builder = builder + temp + " ";
    });
    return builder.trim();
  }
}