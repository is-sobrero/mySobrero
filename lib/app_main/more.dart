// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPG 3.0 license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import 'package:mySobrero/argomenti.dart';
import 'package:mySobrero/assenze.dart';
import 'package:mySobrero/carriera.dart';
import 'package:mySobrero/common/sobreroicons.dart';
import 'package:mySobrero/common/ui.dart';
import 'package:mySobrero/listings/listings_main.dart';
import 'package:mySobrero/localization/localization.dart';
import 'package:mySobrero/materiale.dart';
import 'package:mySobrero/pagelle.dart';
import 'package:mySobrero/reapi3.dart';
import 'package:mySobrero/ricercaaule.dart';
import 'package:mySobrero/sso/sso.dart';
import 'package:mySobrero/tiles/action_tile.dart';
import 'package:mySobrero/ui/helper.dart';
import 'package:mySobrero/ui/layouts.dart';
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

  @override
  Widget build(BuildContext context){
    return SobreroLayout.rPage(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            AppLocalizations.of(context).translate('more'),
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 24,
            ),
          ),
        ),
        WaterfallFlow.count(
          primary: false,
          shrinkWrap: true,
          crossAxisCount: UIHelper.columnCount(context),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            ActionTile(
              builder: (_,__,___) => AssenzeView(apiInstance: widget.apiInstance),
              title: AppLocalizations.of(context).translate('absences'),
              lightImage: "assets/images/assenze_light.png",
              darkImage: "assets/images/assenze_dark.png",
              color: Color(0xffff9692),
              icon: LineIcons.bed,
            ),
            ActionTile(
              builder: (_,__,___) => ArgomentiView(apiInstance: widget.apiInstance),
              title: AppLocalizations.of(context).translate('lessonTopics'),
              lightImage: "assets/images/argomenti_light.png",
              darkImage: "assets/images/argomenti_dark.png",
              color: Color(0xFF5352ed),
              icon: SobreroIcons2.edit,
            ),
            ActionTile(
              builder: (_,__,___) => SSOProvider(session: widget.apiInstance.getSession()),
              title: "Autorizza app",
              lightImage: "assets/images/argomenti_light.png",
              darkImage: "assets/images/argomenti_dark.png",
              color: Color(0xFF5352ed),
              icon: LineIcons.unlock_alt,
            ),
            /*ActionTile(
              builder: (_,__,___) => ListingsHomePage(),
              title: "Resell@Sobrero",
              lightImage: "assets/images/argomenti.png",
              darkImage: "assets/images/argomenti.png",
              color: Color(0xFF5352ed),
              icon: Icons.cloud,
            ),*/
            ActionTile(
              builder: (_,__,___) => MaterialeView(apiInstance: widget.apiInstance),
              title: AppLocalizations.of(context).translate('handouts'),
              lightImage: "assets/images/materiale_light.png",
              darkImage: "assets/images/materiale_dark.png",
              color: Color(0xffe55039),
              icon: LineIcons.hdd_o,
            ),
            ActionTile(
              builder: (_,__,___) => RicercaAuleView(),
              title: AppLocalizations.of(context).translate('searchClass'),
              lightImage: "assets/images/aula_light.png",
              darkImage: "assets/images/aula_dark.png",
              color: Color(0xffF86925),
              icon: SobreroIcons2.map,
            ),
            ActionTile(
              builder: (_,__,___) => PagelleView(apiInstance: widget.apiInstance),
              title: AppLocalizations.of(context).translate('reportCard'),
              lightImage: "assets/images/pagelle_light.png",
              darkImage: "assets/images/pagelle_dark.png",
              color: Color(0xff38ada9),
              icon: SobreroIcons2.alternate_list,
            ),
            ActionTile(
              builder: (_,__,___) => CarrieraView(
                  unifiedLoginStructure: widget.unifiedLoginStructure
              ),
              title: AppLocalizations.of(context).translate('schoolCareer'),
              lightImage: "assets/images/carriera_light.png",
              darkImage: "assets/images/carriera_dark.png",
              color: Color(0xff45BF6D),
              icon: LineIcons.history,
            ),
          ],
        ),
      ],
    );
  }
}