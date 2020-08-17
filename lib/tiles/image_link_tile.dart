// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import 'package:mySobrero/common/utilities.dart';
import 'package:mySobrero/tiles/basic_tile.dart';
import 'package:mySobrero/ui/helper.dart';

class ImageLinkTile extends StatelessWidget {
  ImageLinkTile({
    Key key,
    @required this.colors,
    @required this.title,
    @required this.imageUrl,
    @required this.body,
    this.margin = EdgeInsets.zero,
    @required this.detailsText,
    @required this.detailsUrl
    }) :assert(colors != null),
        assert(title != null),
        assert(imageUrl != null),
        assert(margin != null),
        assert(body != null),
        assert(detailsText != null),
        assert(detailsUrl != null),
        super(key: key);

  List<Color> colors;
  String title;
  String imageUrl;
  String body;
  String detailsText;
  String detailsUrl;
  EdgeInsets margin;

  //TODO: rifare con flex

  @override
  Widget build(BuildContext context) {
    return BasicTile(
      margin: margin,
      overridePadding: true,
      child: IntrinsicHeight(
        child: Flex(
          direction: UIHelper.isWide(context) ? Axis.horizontal : Axis.vertical,
          children: [
            Container(
              width: UIHelper.isWide(context) ? 300 : null,
              height: UIHelper.isWide(context) ? double.infinity : 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    imageUrl,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        title,
                        style: new TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(body),
                    FlatButton(
                      child: Row(
                        children: [
                          Text(
                            detailsText,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(LineIcons.arrow_right),
                        ],
                      ),
                      onPressed: () => openURL(context, detailsUrl),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}