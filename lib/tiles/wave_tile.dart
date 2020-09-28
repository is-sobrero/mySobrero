// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:mySobrero/common/definitions.dart';
import 'package:mySobrero/tiles/ratio_tile.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

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
              Padding(
                padding: const EdgeInsets.all(15),
                child: child,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

