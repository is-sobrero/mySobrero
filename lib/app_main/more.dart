// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPG 3.0 license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import 'package:mySobrero/argomenti.dart';
import 'package:mySobrero/assenze.dart';
import 'package:mySobrero/carriera.dart';
import 'package:mySobrero/common/tiles.dart';
import 'package:mySobrero/localization/localization.dart';
import 'package:mySobrero/materiale.dart';
import 'package:mySobrero/pagelle.dart';
import 'package:mySobrero/reAPI/reapi.dart';
import 'package:mySobrero/ricercaaule.dart';
import 'package:mySobrero/snacks/snacks_view.dart';
import 'package:mySobrero/tiles/action_tile.dart';
import 'package:mySobrero/tiles/basic_tile.dart';
import 'package:mySobrero/ui/helper.dart';
import 'package:mySobrero/ui/layouts.dart';
import 'package:mySobrero/ui/list_button.dart';
import 'package:mySobrero/weather/weather.dart';
import 'package:mySobrero/weather/weather_model.dart';
import 'package:mySobrero/common/utilities.dart';
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

  _openPage (StatefulWidget view) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (a,b,c) => view,
        transitionDuration: Duration(milliseconds: UIHelper.pageAnimDuration),
        transitionsBuilder: (ctx, prim, sec, child) => SharedAxisTransition(
          animation: prim,
          secondaryAnimation: sec,
          transitionType: SharedAxisTransitionType.scaled,
          child: child,
        ),
      ),
    );
  }

  Future<WeatherModel> _futureWeather;

  @override
  void initState(){
    super.initState();
    _futureWeather = OWMProvider.instance.getWeather();
  }

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
            FutureBuilder<WeatherModel>(
              future: _futureWeather,
              builder: (context, snapshot){
                switch (snapshot.connectionState){
                  case ConnectionState.none:
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Container();
                  case ConnectionState.done:
                    if (snapshot.hasError)
                      return Container();
                    Current _data = snapshot.data.current;
                    int _selectedImage = Random.secure().nextInt(4);
                    if (_selectedImage == 0)
                      _selectedImage = 1;
                    return BasicTile(
                      overridePadding: true,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.asset(
                              "assets/images/casale0$_selectedImage.jpg",
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.black87, Colors.transparent],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: "https://openweathermap.org/img/wn/${_data.weather.first.icon}@2x.png",
                                          height: 40,
                                        ),
                                        Text(
                                          _data.temp.toStringAsFixed(0) + "°C",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            color: Colors.white
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        _data.weather.first.description.capitalize()
                                            + " a Casale Monferrato",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    );
                }
                return null;
              },
            ),
            SobreroFlatTile(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 7),
                        child: Icon(
                          TablerIcons.book,
                          size: 25,
                          color: Color(0xFF5352ed),
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context).translate(
                          'MORE_DIDACTICS_SECTION',
                        ),
                        style: TextStyle(
                          color: Color(0xFF5352ed),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SobreroListButton(
                  title: AppLocalizations.of(context).translate(
                    'LESSON_TOPICS',
                  ),
                  caption: AppLocalizations.of(context).translate(
                    'LESSON_TOPICS_DESC',
                  ),
                  icon: TablerIcons.edit,
                  onPressed: () => _openPage(ArgomentiView()),
                  color: Color(0xFF5352ed),
                ),
                SobreroListButton(
                  title: AppLocalizations.of(context).translate(
                    'REPORT_CARDS',
                  ),
                  caption: AppLocalizations.of(context).translate(
                    'REPORT_CARDS_DESC',
                  ),
                  icon: TablerIcons.list,
                  onPressed: () => _openPage(PagelleView()),
                  color: Color(0xFF5352ed),
                ),
                SobreroListButton(
                  title: AppLocalizations.of(context).translate(
                    'CAREER',
                  ),
                  caption: AppLocalizations.of(context).translate(
                    'CAREER_DESC',
                  ),
                  icon: TablerIcons.history,
                  onPressed: () => _openPage(CarrieraView()),
                  color: Color(0xFF5352ed),
                ),
                SobreroListButton(
                  title: AppLocalizations.of(context).translate(
                    'HANDOUTS',
                  ),
                  caption: AppLocalizations.of(context).translate(
                    'HANDOUTS_DESC',
                  ),
                  icon: TablerIcons.cloud_download,
                  onPressed: () => _openPage(MaterialeView()),
                  color: Color(0xFF5352ed),
                  showBorder: false,
                ),
              ],
            ),
            ActionTile(
              builder: (_,__,___) => AssenzeView(),
              title: AppLocalizations.of(context).translate('absences'),
              lightImage: "assets/images/assenze_light.png",
              darkImage: "assets/images/assenze_dark.png",
              color: Color(0xffff9692),
              icon: TablerIcons.bed,
            ),
            // Blocchiamo l'accesso a Snacks@Sobrero a chi non è studente
            if (reAPI4.instance.getStartupCache().user.level == "4") ActionTile(
              builder: (_,__,___) => SnacksView(),
              title: "Snacks@Sobrero",
              lightImage: "assets/images/argomenti_light.png",
              darkImage: "assets/images/argomenti_dark.png",
              color: Color(0xFF5352ed),
              icon: Icons.fastfood,
            ),
            ActionTile(
              builder: (_,__,___) => RicercaAuleView(),
              title: AppLocalizations.of(context).translate('searchClass'),
              lightImage: "assets/images/aula_light.png",
              darkImage: "assets/images/aula_dark.png",
              color: Color(0xffF86925),
              icon: TablerIcons.map_2,
            ),
          ],
        ),
      ],
    );
  }
}