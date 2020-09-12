// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPG 3.0 license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:mySobrero/ui/skeleton.dart';
import 'package:animations/animations.dart';
import 'package:mySobrero/tiles/basic_tile.dart';

class SobreroNewsTile extends StatelessWidget {
  SobreroNewsTile({
    Key key,
    this.safeLeft = false,
    this.safeRight = false,
    this.leadingImageUrl,
    this.title,
    this.builder,
  }) :  assert(leadingImageUrl != null),
        assert(title != null),
        assert(builder != null),
        super(key: key);

  bool safeLeft, safeRight;
  String leadingImageUrl, title;

  final Function(BuildContext, Animation<double>, Animation<double>) builder;

  @override
  Widget build (BuildContext context) => SafeArea(
    bottom: false,
    left: safeLeft,
    right: safeRight,
    top: false,
    child: BasicTile(
      width: 300,
      margin: EdgeInsets.only(right: 15),
      overridePadding: true,
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: builder,
            transitionDuration: Duration(milliseconds: 600),
            transitionsBuilder: (ctx, prim, sec, child) => SharedAxisTransition(
              animation: prim,
              secondaryAnimation: sec,
              transitionType: SharedAxisTransitionType.scaled,
              child: child,
            ),
          ),
        ),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: leadingImageUrl,
                placeholder: (context, url) => Skeleton(),
                errorWidget: (context, _, __) => Container(
                  color: Theme.of(context).textTheme.bodyText1.color.withAlpha(40),
                  width: 300,
                  child: Center(
                    child: Icon(TablerIcons.anchor, size: 70),
                  ),
                ),
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black87, Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(15,30,15,25),
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}