// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPG 3.0 license that can be
// found in the LICENSE file.

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import 'package:mySobrero/tiles/basic_tile.dart';
import 'package:mySobrero/ui/helper.dart';

class ActionTile extends StatelessWidget {
  ActionTile({
    Key key,
    @required this.builder,
    @required this.title,
    @required this.lightImage,
    @required this.darkImage,
    @required this.color,
    @required this.icon,
  }) :  assert(builder != null),
        assert(title != null),
        assert(lightImage != null),
        assert(darkImage != null),
        assert(color != null),
        assert(icon != null),
        super(key: key);

  /// Route builder passed to the Navigator when the [IllustrationTile] is
  /// tapped
  final Function(BuildContext, Animation<double>, Animation<double>) builder;

  /// The title for [IllustrationTile]
  final String title;

  /// Relative path to the leading light image of the [IllustrationTile]
  final String lightImage;

  /// Relative path to the leading dark image of the [IllustrationTile]
  final String darkImage;

  /// Foreground color of the tile
  final Color color;

  /// Leading icon
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: builder,
          transitionDuration: Duration(milliseconds: UIHelper.pageAnimDuration),
          transitionsBuilder: (ctx, prim, sec, child) => SharedAxisTransition(
            animation: prim,
            secondaryAnimation: sec,
            transitionType: SharedAxisTransitionType.scaled,
            child: child,
          ),
        ),
      ),
      child: BasicTile(
        height: 150,
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(
                  icon,
                  color: color,
                  size: 23,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: color
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            Image.asset(
              Theme.of(context).brightness == Brightness.light ?
              lightImage : darkImage,
            ),
          ],
        ),
      ),
    );
  }
}