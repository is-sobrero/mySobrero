// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

// TODO: pulizia codice carriera

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mySobrero/common/tiles.dart';
import 'package:mySobrero/reAPI/reapi.dart';
import 'package:mySobrero/reAPI/types.dart';
import 'package:mySobrero/ui/detail_view.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CarrieraView extends StatefulWidget {
  CarrieraView({Key key}) : super(key: key);
  @override
  _CarrieraState createState() => _CarrieraState();
}

class _CarrieraState extends State<CarrieraView> {

  int creditiPresiTotali = 0;
  int creditiNonPresiTotali = 0;

  @override
  void initState() {
    super.initState();
    reAPI4.instance.getStartupCache().user.curriculum.forEach((item) {
      final int anno = int.parse(item.fullclass.substring(0, 1));
      int credito = -1;
      if (item.points.length > 0) credito = int.parse(item.points.trim());
      int maxCredito = 12;
      if (anno == 4) maxCredito = 13;
      if (anno == 5) maxCredito = 15;
      if (credito > 0 && anno >= 3) {
        creditiNonPresiTotali += (maxCredito - credito);
        creditiPresiTotali += credito;
      }
    });
    print("Crediti presi: $creditiPresiTotali, Crediti non presi: $creditiNonPresiTotali");
  }

  Widget _generaAnno(Curriculum anno){
    Color scaffoldColor;

    if (!anno.outcome.contains("AMMESS")){
      if (anno.points.length == 0) scaffoldColor = Color(0xff0652DD);
      else if (anno.outcome.length == 0) scaffoldColor = null;
      else scaffoldColor = Colors.red;
    }

    Color txtColor = scaffoldColor == null ? Theme.of(context).textTheme.bodyText1.color : Colors.white;
    return SobreroFlatTile(
      margin: EdgeInsets.only(bottom: 15),
      color: scaffoldColor,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: <Widget>[
              Text("Classe ${anno.fullclass}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: txtColor
                ),
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: txtColor.withAlpha(20),
                          blurRadius: 10,
                          spreadRadius: 5
                      )
                    ]
                ),
                child: Chip(
                  label: Text(
                    anno.points.length == 0 ? "Anno in corso" : "${anno.points} crediti",
                    style: TextStyle(color: Colors.black),
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: Colors.white,
                ),
              )
            ],
          ),
        ),
        Text(anno.course,
            style: TextStyle(fontSize: 16, color: txtColor, fontWeight: FontWeight.bold,)),
        Text("Anno scolastico ${anno.year}",
            style: TextStyle(fontSize: 16, color: txtColor)),
        anno.outcome.length > 0 ? Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(anno.outcome,
              style: TextStyle(fontSize: 16, color: txtColor)),
        ) : Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SobreroDetailView(
      title: "Carriera scolastica",
      child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  CircularPercentIndicator(
                    radius: 190,
                    lineWidth: 15,
                    percent: (creditiNonPresiTotali + creditiPresiTotali) / 40,
                    animation: true,
                    animationDuration: 300,
                    animateFromLastPercent: true,
                    circularStrokeCap: CircularStrokeCap.round,
                    center: Container(
                        width: 130,
                        child: AutoSizeText(
                          "$creditiPresiTotali crediti presi\n$creditiNonPresiTotali crediti non presi\n${40-creditiPresiTotali} crediti ancora da prendere",
                          minFontSize: 10,
                          maxLines: 4,
                          style: TextStyle(fontSize: 25),
                          textAlign: TextAlign.center,
                        )
                    ),
                    backgroundColor: Colors.transparent,
                    linearGradient: LinearGradient(
                        colors: <Color>[Color(0xfff9d423), Color(0xffff4e50)]
                    ),
                  ),
                  CircularPercentIndicator(
                    radius: 190,
                    lineWidth: 15,
                    percent: creditiPresiTotali / 40,
                    animation: true,
                    animationDuration: 300,
                    animateFromLastPercent: true,
                    circularStrokeCap: CircularStrokeCap.round,
                    center: Container(
                        width: 130,
                        child: AutoSizeText(
                          "$creditiPresiTotali crediti presi\n$creditiNonPresiTotali crediti non presi\n${40-creditiPresiTotali} crediti ancora da prendere",
                          minFontSize: 10,
                          maxLines: 4,
                          style: TextStyle(fontSize: 25),
                          textAlign: TextAlign.center,
                        )
                    ),
                    backgroundColor: Theme.of(context).textTheme.bodyText1.color.withOpacity(0.1),
                    linearGradient: LinearGradient(
                        colors: <Color>[Color(0xff2af598), Color(0xff009efd)]
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ListView.builder(
                  addAutomaticKeepAlives: true,
                  primary: false,
                  shrinkWrap: true,
                  itemCount: reAPI4.instance.getStartupCache().user.curriculum.length,
                  itemBuilder: (context, i) => _generaAnno(
                    reAPI4.instance.getStartupCache().user.curriculum[i],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
