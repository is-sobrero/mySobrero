// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:mySobrero/common/definitions.dart';

class SobreroGradientTile extends StatelessWidget {
  SobreroGradientTile({
    Key key,
    @required this.children,
    this.colors,
    this.showShadow = true,
    this.padding = EdgeInsets.zero,
    this.overrideGradient = false,
    this.layoutBuilder = defaultLayoutBuilder,
    this.overridePadding = false,
    this.crossAxisAlignment = CrossAxisAlignment.start
  }) :  assert(crossAxisAlignment != null),
        assert(children != null),
        assert(colors != null || overrideGradient),
        assert((colors?.length ?? 0) > 0 || overrideGradient),
        super(key: key);

  final CrossAxisAlignment crossAxisAlignment;
  final List<Widget> children;
  final EdgeInsets padding;
  final List<Color> colors;
  final bool showShadow, overridePadding, overrideGradient;
  final TileLayoutBuilder layoutBuilder;

  static Widget defaultLayoutBuilder(
      EdgeInsets padding,
      bool showShadow,
      List<Color> colors,
      bool overrideGradient,
      bool overridePadding,
      Widget child,
  ) => Container(
    margin: padding,
    decoration: new BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        if (showShadow) BoxShadow(
          color: colors[0].withOpacity(0.4),
          blurRadius: 10,
          //spreadRadius: 10,
        ),
      ],
      gradient: !overrideGradient ? LinearGradient(
          begin: FractionalOffset.topRight,
          end: FractionalOffset.bottomRight,
          colors: colors
      ) : null,
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: EdgeInsets.all(overridePadding ? 0 : 15),
        child: child,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => layoutBuilder(
    padding,
    showShadow,
    colors,
    overrideGradient,
    overridePadding,
    Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...children,
      ],
    ),
  );
}
