// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPG 3.0 license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:mySobrero/argomenti.dart';
import 'package:mySobrero/assenze.dart';
import 'package:mySobrero/carriera.dart';
import 'package:mySobrero/common/ui.dart';
import 'package:mySobrero/materiale.dart';
import 'package:mySobrero/pagelle.dart';
import 'package:mySobrero/reapi3.dart';
import 'package:mySobrero/common/tiles.dart';
import 'package:mySobrero/ricercaaule.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class MorePageView extends StatefulWidget {
  UnifiedLoginStructure unifiedLoginStructure;
  reAPI3 apiInstance;

  MorePageView({
    Key key,
    @required this.apiInstance,
    @required this.unifiedLoginStructure,
  }) :  assert(apiInstance != null),
        assert(unifiedLoginStructure != null),
        super(key: key);

  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePageView>
    with AutomaticKeepAliveClientMixin<MorePageView>{

  @override
  bool get wantKeepAlive => true;

  UIHelper _uiHelper;

  @override
  void initState(){
    super.initState();
    _uiHelper = UIHelper(context: context);
  }

  @override
  Widget build(BuildContext context){
    return MainViewSimpleContainer(
      title: "Altro",
      children: [
        WaterfallFlow.count(
          primary: false,
          shrinkWrap: true,
          crossAxisCount: _uiHelper.columnCount,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            IllustrationTile(
              builder: (_) => AssenzeView(apiInstance: widget.apiInstance),
              tag: "assenze_background",
              title: "Assenze",
              image: "assets/images/assenze.png",
              color: Color(0xffff9692),
            ),
            IllustrationTile(
              builder: (_) => ArgomentiView(apiInstance: widget.apiInstance),
              tag: "argomenti_background",
              title: "Argomenti",
              image: "assets/images/argomenti.png",
              color: Color(0xFF5352ed),
            ),
            IllustrationTile(
              builder: (_) => MaterialeView(apiInstance: widget.apiInstance),
              tag: "materiale_background",
              title: "Materiale didattico",
              image: "assets/images/material.png",
              color: Color(0xffe55039),
            ),
            IllustrationTile(
              builder: (_) => RicercaAuleView(),
              tag: "ricercaaule_background",
              title: "Ricerca aule",
              image: "assets/images/ricercaaule.png",
              color: Color(0xffF86925),
            ),
            IllustrationTile(
              builder: (_) => PagelleView(apiInstance: widget.apiInstance),
              tag: "pagelle_background",
              title: "Pagelle",
              image: "assets/images/pagelle.png",
              color: Color(0xff38ada9),
            ),
            IllustrationTile(
              builder: (_) => CarrieraView(
                  unifiedLoginStructure: widget.unifiedLoginStructure
              ),
              tag: "carriera_background",
              title: "Carriera scolastica",
              image: "assets/images/carriera.png",
              color: Color(0xff45BF6D),
            ),
          ],
        ),
      ],
    );
  }
}