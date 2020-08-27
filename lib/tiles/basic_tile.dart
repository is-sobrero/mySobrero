// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPG 3.0 license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class BasicTile extends StatelessWidget {
  BasicTile({
    Key key,
    @required this.child,
    this.color,
    this.showShadow = true,
    this.margin = EdgeInsets.zero,
    this.height,
    this.width,
    this.overridePadding = false,
  }) :  assert(child != null),
        super(key: key);

  final Widget child;
  final EdgeInsets margin;
  final Color color;
  final bool showShadow, overridePadding;
  final double width, height;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      height: height,
      decoration: new BoxDecoration(
        color: color ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          if (showShadow) BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 10,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(overridePadding ? 0 : 15),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: child,
        )
      ),
    );
  }
}
