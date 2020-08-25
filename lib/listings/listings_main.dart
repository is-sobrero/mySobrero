// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mySobrero/common/tiles.dart';

import 'package:mySobrero/common/ui.dart';
import 'package:mySobrero/listings/listings_detail.dart';
import 'package:mySobrero/tiles/leading_image.dart';
import 'package:mySobrero/ui/button.dart';
import 'package:mySobrero/ui/detail_view.dart';

class ListingsHomePage extends StatefulWidget {
  ListingsHomePage({
    Key key
  }) : super(key: key);

  @override
  _ListingsHomeState createState() => _ListingsHomeState();
}

class _ListingsHomeState extends State<ListingsHomePage> {
  @override
  Widget build(BuildContext context){
    return SobreroDetailView(
      title: "Resell@Sobrero",
      overridePadding: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SobreroTextField(
            hintText: "Cerca qualcosa",
            margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
            suffixIcon: IconButton(
              icon: Icon(LineIcons.search),
              color: Theme.of(context).primaryColor,
              onPressed: () => print("ok"),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: SobreroButton(
                  margin: EdgeInsets.only(right: 5, left: 15),
                  text: "Aggiungi",
                  color: Theme.of(context).primaryColor,
                  suffixIcon: Icon(LineIcons.plus),
                  onPressed: () => print("ok"),
                ),
              ),
              Flexible(
                child: SobreroButton(
                  text: "Gestisci",
                  margin: EdgeInsets.fromLTRB(5,0,15,15),
                  color: Theme.of(context).primaryColor,
                  suffixIcon: Icon(LineIcons.list),
                  onPressed: () => print("ok"),
                ),
              ),
            ],
          ),
          HorizontalSectionList(
            sectionTitle: "Ultimi annunci",
            itemCount: 4,
            height: 220,
            itemBuilder: (left, right, i) => LeadingImageTile(
              leadingImageUrl: 'https://picsum.photos/200/300',
              width: 150,
              height: 220,
              showTitle: false,
              safeLeft: left,
              safeRight: right,
              detailView: ListingsDetailPage(),
              tappable: true,
            ),

          ),
          HorizontalSectionList(
            sectionTitle: "Libri",
            itemCount: 4,
            height: 220,
            itemBuilder: (left, right, i) => LeadingImageTile(
              leadingImageUrl: 'https://picsum.photos/200/300',
              width: 150,
              height: 220,
              showTitle: false,
              safeLeft: left,
              safeRight: right,
            ),
          ),
          HorizontalSectionList(
            sectionTitle: "Ripetizioni",
            itemCount: 4,
            height: 220,
            itemBuilder: (left, right, i) => LeadingImageTile(
              leadingImageUrl: 'https://picsum.photos/200/300',
              width: 150,
              height: 220,
              showTitle: false,
              safeLeft: left,
              safeRight: right,
            ),
          ),
          HorizontalSectionList(
            sectionTitle: "Vario",
            itemCount: 4,
            height: 220,
            itemBuilder: (left, right, i) => LeadingImageTile(
              leadingImageUrl: 'https://picsum.photos/200/300',
              width: 150,
              height: 220,
              showTitle: false,
              safeLeft: left,
              safeRight: right,
            ),
          ),
        ],
      ),
    );
  }
}