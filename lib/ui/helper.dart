// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class UIHelper {

  static bool isWide(context) => MediaQuery.of(context).size.width > 500;

  static int columnCount (context) {
    int columnCount = MediaQuery.of(context).size.width > 550 ? 2 : 1;
    columnCount = MediaQuery.of(context).size.width > 900 ? 3 : columnCount;
    return columnCount;
  }

  static Color textColorByBackground (Color color) =>
      color.computeLuminance() > 0.45 ? Colors.black : Colors.white;
}