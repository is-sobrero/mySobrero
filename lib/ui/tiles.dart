// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class SobreroGradientTile extends StatelessWidget {
  SobreroGradientTile({
    Key key,
    @required this.children,
    @required this.colors,
    this.showShadow = true,
    this.margin = EdgeInsets.zero,
    this.overridePadding = false,
    this.crossAxisAlignment = CrossAxisAlignment.stretch
  }) :  assert(crossAxisAlignment != null),
        assert(children != null),
        assert(colors != null),
        assert(colors.length > 0),
        super(key: key);

  CrossAxisAlignment crossAxisAlignment;
  List<Widget> children;
  EdgeInsets margin;
  List<Color> colors;
  bool showShadow, overridePadding;

  @override
  Widget build(BuildContext context) => Container(
    margin: margin,
    decoration: new BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        if (showShadow) BoxShadow(
          color: Colors.black.withAlpha(12),
          blurRadius: 10,
          spreadRadius: 10,
        ),
      ],
      gradient: LinearGradient(
          begin: FractionalOffset.topRight,
          end: FractionalOffset.bottomRight,
          colors: colors
      ),
    ),
    child: Padding(
      padding: EdgeInsets.all(overridePadding ? 0 : 15),
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          ...children,
        ],
      ),
    ),
  );
}