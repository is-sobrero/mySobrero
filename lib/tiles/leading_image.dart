// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

// TODO: pulizia codice tiles 570

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mySobrero/common/skeleton.dart';

class LeadingImageTile extends StatelessWidget {
  LeadingImageTile({
    Key key,
    this.safeLeft = false,
    this.safeRight = false,
    @required this.leadingImageUrl,
    this.width = 300,
    this.height,
    this.title = '',
    this.tappable = false,
    this.showTitle = true,
    this.detailView
  }) :  assert(safeRight != null),
        assert(safeLeft != null),
        assert(leadingImageUrl != null),
        assert(width != null),
        assert(title != null),
        assert(tappable != null),
        super(key: key);

  bool safeLeft, safeRight;
  bool showTitle;
  String leadingImageUrl;
  double width, height;
  StatefulWidget detailView;
  bool tappable;
  String title;

  @override
  Widget build (BuildContext context){
    return SafeArea(
      bottom: false,
      left: safeLeft,
      right: safeRight,
      top: false,
      child: Padding(
        padding: EdgeInsets.only(right: 15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(30),
                blurRadius: 10,
                spreadRadius: 5,
              )
            ],
          ),
          width: width,
          height: height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: OpenContainer(
              closedColor: Theme.of(context).scaffoldBackgroundColor,
              openColor: Theme.of(context).scaffoldBackgroundColor,
              closedBuilder: (c, action) => Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl: leadingImageUrl,
                      placeholder: (context, url) => Skeleton(),
                      errorWidget: (context, url, error) => Container(
                        color: Theme.of(context).textTheme.bodyText1.color.withAlpha(40),
                        width: width,
                        child: Center(
                          child: Icon(Icons.broken_image, size: 70),
                        ),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (showTitle) Container(
                    width: width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black87, Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15,30,15,25),
                      child: Text(
                        title,
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 24,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              openBuilder: (c, action) => detailView,
              tappable: tappable,
            ),
          ),
        ),
      ),
    );
  }
}