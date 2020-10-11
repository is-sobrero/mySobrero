// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPG 3.0 license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import 'package:mySobrero/argomenti.dart';
import 'package:mySobrero/assenze.dart';
import 'package:mySobrero/carriera.dart';
import 'package:mySobrero/localization/localization.dart';
import 'package:mySobrero/materiale.dart';
import 'package:mySobrero/pagelle.dart';
import 'package:mySobrero/ricercaaule.dart';
import 'package:mySobrero/snacks/snacks_view.dart';
import 'package:mySobrero/tiles/action_tile.dart';
import 'package:mySobrero/ui/helper.dart';
import 'package:mySobrero/ui/layouts.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class MorePageView extends StatefulWidget {
  MorePageView({
    Key key,
  }) :  super(key: key);

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
              builder: (_,__,___) => AssenzeView(),
              title: AppLocalizations.of(context).translate('absences'),
              lightImage: "assets/images/assenze_light.png",
              darkImage: "assets/images/assenze_dark.png",
              color: Color(0xffff9692),
              icon: TablerIcons.bed,
            ),
            ActionTile(
              builder: (_,__,___) => ArgomentiView(),
              title: AppLocalizations.of(context).translate('lessonTopics'),
              lightImage: "assets/images/argomenti_light.png",
              darkImage: "assets/images/argomenti_dark.png",
              color: Color(0xFF5352ed),
              icon: TablerIcons.edit,
            ),
            ActionTile(
              builder: (_,__,___) => SnacksView(),
              title: "Snacks@Sobrero",
              lightImage: "assets/images/argomenti_light.png",
              darkImage: "assets/images/argomenti_dark.png",
              color: Color(0xFF5352ed),
              icon: Icons.fastfood,
            ),
            ActionTile(
              builder: (_,__,___) => MaterialeView(),
              title: AppLocalizations.of(context).translate('handouts'),
              lightImage: "assets/images/materiale_light.png",
              darkImage: "assets/images/materiale_dark.png",
              color: Color(0xffe55039),
              icon: TablerIcons.cloud_download,
            ),
            ActionTile(
              builder: (_,__,___) => RicercaAuleView(),
              title: AppLocalizations.of(context).translate('searchClass'),
              lightImage: "assets/images/aula_light.png",
              darkImage: "assets/images/aula_dark.png",
              color: Color(0xffF86925),
              icon: TablerIcons.map_2,
            ),
            ActionTile(
              builder: (_,__,___) => PagelleView(),
              title: AppLocalizations.of(context).translate('reportCard'),
              lightImage: "assets/images/pagelle_light.png",
              darkImage: "assets/images/pagelle_dark.png",
              color: Color(0xff38ada9),
              icon: TablerIcons.list,
            ),
            ActionTile(
              builder: (_,__,___) => CarrieraView(),
              title: AppLocalizations.of(context).translate('schoolCareer'),
              lightImage: "assets/images/carriera_light.png",
              darkImage: "assets/images/carriera_dark.png",
              color: Color(0xff45BF6D),
              icon: TablerIcons.history,
            ),
          ],
        ),
      ],
    );
  }
}