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
  TileLayoutBuilder get layoutBuilder => (child) => Expanded(
    flex: flex,
    child: Container(
      margin: margin,
      child: GestureDetector(
        onTap: onTap,
        child: AspectRatio(
            aspectRatio: aspectRatio,
            child: child
        ),
      ),
    ),
  );
}
