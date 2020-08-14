// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mySobrero/common/definitions.dart';
import 'package:mySobrero/common/skeleton.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

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

  CrossAxisAlignment crossAxisAlignment;
  List<Widget> children;
  EdgeInsets padding;
  List<Color> colors;
  bool showShadow, overridePadding, overrideGradient;
  TileLayoutBuilder layoutBuilder;

  static Widget defaultLayoutBuilder(child) => child;

  @override
  Widget build(BuildContext context) => layoutBuilder(
    Container(
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
      child: Padding(
        padding: EdgeInsets.all(overridePadding ? 0 : 15),
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...children,
          ],
        ),
      ),
    ),
  );
}

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

class SobreroWaveTile extends SobreroRatioTile {
  SobreroWaveTile ({
    Key key,
    double aspectRatio = 1,
    int flex,
    this.margin = EdgeInsets.zero,
    EdgeInsets padding = EdgeInsets.zero,
    @required this.numberMark,
    @required Function onTap,
    @required children,
    @required this.color,
  }) :  assert(aspectRatio != null),
        assert(children != null),
        assert(color != null),
        super(
          key: key,
          children: children,
          //margin: padding,
          overrideGradient: true,
          showShadow: false,
          flex: flex,
          aspectRatio: aspectRatio,
          onTap: onTap,
          colors: [color],
        );

  EdgeInsets margin;
  Color color;
  double numberMark;

  @override
  TileLayoutBuilder get layoutBuilder => (child) => Expanded(
    flex: flex,
    child: Container(
      margin: margin,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 10,
          ),
        ]
      ),
      child: GestureDetector(
        onTap: onTap,
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: WaveWidget(
                  config: CustomConfig(
                    colors: [
                      Colors.white38,
                      Colors.white30,
                      Colors.white24,
                    ],
                    durations: [32000, 21000, 18000],
                    heightPercentages: [
                      1 - numberMark/10,
                      1 - numberMark/10 + 0.1,
                      1 - numberMark/10 + 0.2,
                    ],
                    blur: MaskFilter.blur(BlurStyle.solid, 10),
                  ),
                  backgroundColor: color,
                  duration: 500,
                  waveAmplitude: 0,
                  size: Size(
                    double.infinity,
                    double.infinity,
                  ),
                ),
              ),
              child,
            ],
          ),
        ),
      ),
    ),
  );
}

