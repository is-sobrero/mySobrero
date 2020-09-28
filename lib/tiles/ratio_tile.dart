// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:mySobrero/tiles/gradient_tile.dart';
import 'package:mySobrero/common/definitions.dart';

class SobreroRatioTile extends SobreroGradientTile {
  SobreroRatioTile ({
    Key key,
    this.aspectRatio = 1,
    this.flex,
    EdgeInsets padding = EdgeInsets.zero,
    @required this.onTap,
    overrideGradient = false,
    colors,
    this.margin = EdgeInsets.zero,
    showShadow = true,
    @required children,
  }) :  assert(aspectRatio != null),
        assert(colors != null || overrideGradient),
        assert((colors?.length ?? 0) > 0 || overrideGradient),
        assert(children != null),
        super(
          key: key,
          children: children,
          colors: colors,
          overrideGradient: overrideGradient,
          padding: padding,
          showShadow: showShadow
      );

  final double aspectRatio;
  final int flex;
  final Function onTap;
  final EdgeInsets margin;

  @override
  TileLayoutBuilder get layoutBuilder => (
      EdgeInsets padding,
      bool showShadow,
      List<Color> colors,
      bool overrideGradient,
      bool overridePadding,
      Widget child,
  ) => Expanded(
    flex: flex,
    child: Container(
      margin: margin,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: colors[1].withOpacity(0.4),
              blurRadius: 10,
            ),
          ]
      ),
      child: GestureDetector(
        onTap: onTap,
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              margin: padding,
              decoration: BoxDecoration(
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
              child: Padding(
                padding: EdgeInsets.all(overridePadding ? 0 : 15),
                child: child,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
