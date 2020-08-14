// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPG 3.0 license that can be
// found in the LICENSE file.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:mySobrero/feed/sobrero_feed.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mySobrero/ui/detail_view.dart';


class FeedDetailView extends StatefulWidget {
  Items articolo;
  FeedDetailView({Key key, @required this.articolo}) : super(key: key);
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<FeedDetailView> {
  void openURL(BuildContext context, String url) async {
    try {
      await launch(
        url,
        option: new CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          extraCustomTabs: <String>[
            'org.mozilla.firefox',
            'com.microsoft.emmx',
          ],
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SobreroDetailView(
      title: widget.articolo.title,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 10
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        widget.articolo.thumbnail
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Html(
              data: widget.articolo.content,
              padding: EdgeInsets.only(top: 10),
              showImages: false,
              onLinkTap: (url) {
                openURL(context, url);
              }
          ),
        ],
      ),
    );
  }

}