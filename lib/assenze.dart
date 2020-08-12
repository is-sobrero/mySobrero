// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:io' show Platform;

import 'package:mySobrero/common/tiles.dart';
import 'package:mySobrero/common/utilities.dart';
import 'package:mySobrero/localization/localization.dart';
import 'package:mySobrero/reapi3.dart';
import 'package:mySobrero/ui/data_ui.dart';
import 'package:mySobrero/ui/detail_view.dart';
import 'package:mySobrero/ui/helper.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

// TODO: pulizia codice assenze
// TODO: empty state

class AssenzeView extends StatefulWidget {
  reAPI3 apiInstance;

  AssenzeView({Key key, @required this.apiInstance}) : super(key: key);
  @override
  _AssenzeState createState() => _AssenzeState();
}

class _AssenzeState extends State<AssenzeView> {

  @override
  void initState() {
    super.initState();
    _assenze = widget.apiInstance.retrieveAssenze();
  }

  Future<AssenzeStructure> _assenze;

  @override
  Widget build(BuildContext context) {
    return SobreroDetailView(
      title: AppLocalizations.of(context).translate('absences'),
      child: FutureBuilder<AssenzeStructure>(
        future: _assenze,
        builder: (context, snapshot){
          switch (snapshot.connectionState){
            case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return SobreroLoading(
                  loadingStringKey: "loadingAbsences",
                );
                case ConnectionState.done:
                if (snapshot.hasError)
                  return SobreroError(
                    snapshotError: snapshot.error,
                  );
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 15),
                        child: Text(
                          AppLocalizations.of(context).translate('notJustified'),
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ),
                      snapshot.data.nongiustificate.length > 0 ?
                      WaterfallFlow.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: snapshot.data.nongiustificate.length,
                        itemBuilder: (_, i) => _displayAbsence(
                          snapshot.data.nongiustificate[i],
                          true,
                        ),
                        gridDelegate: SliverWaterfallFlowDelegate(
                          crossAxisCount: UIHelper.columnCount(context),
                          mainAxisSpacing: 15.0,
                          crossAxisSpacing: 15.0,
                          lastChildLayoutTypeBuilder: (i) =>
                          i == snapshot.data.nongiustificate.length ? LastChildLayoutType.foot
                              : LastChildLayoutType.none,
                        ),
                      ) : SobreroEmptyState(
                        emptyStateKey: "noAbsencesWOJustification",
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Text(
                          AppLocalizations.of(context).translate(
                            'absencesWithJustification',
                          ),
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                      WaterfallFlow.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: snapshot.data.giustificate.length,
                        itemBuilder: (_, i) => _displayAbsence(
                          snapshot.data.giustificate[i],
                          false,
                        ),
                        gridDelegate: SliverWaterfallFlowDelegate(
                          crossAxisCount: UIHelper.columnCount(context),
                          mainAxisSpacing: 15.0,
                          crossAxisSpacing: 15.0,
                          lastChildLayoutTypeBuilder: (i) =>
                          i == snapshot.data.giustificate.length ? LastChildLayoutType.foot
                              : LastChildLayoutType.none,
                        ),
                      ),
                    ]
                );
          }
            return null;
          },
      ),
    );
  }

  Widget _displayAbsence(AssenzaStructure a, bool notJustified) {
    Color txtColor = notJustified ? Colors.white : null;
    String typeID = AppLocalizations.of(context).translate('absence');
    if (a.tipologia == "Ritardo")
      typeID = AppLocalizations.of(context).translate('delay');
    if (a.tipologia == "Uscita")
      typeID = AppLocalizations.of(context).translate('earlyCK');
    final f = new DateFormat('dd/MM/yyyy HH:mm:ss');
    DateTime timestamp = f.parse("${a.data} ${a.orario ?? "00:00:00"}");

    final day = DateFormat.MMMMd(Platform.localeName).format(timestamp);
    final time = DateFormat('hh:mm').format(timestamp);
    return SobreroFlatTile(
      //margin: EdgeInsets.only(top: 15),
      color: notJustified ? Colors.red : null,
      children: [
        Row(
          children: [
            Text(
              typeID,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: txtColor,
              ),
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: <Widget>[
                    Text(
                      day,
                      style: TextStyle(color: txtColor),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: Icon(
                        LineIcons.calendar_o,
                        size: 18,
                        color: txtColor,
                      ),
                    )
                  ],
                ),
                if (a.tipologia != "Assenza") Row(
                  children: <Widget>[
                    Text(
                      time,
                      style: TextStyle(color: txtColor),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: Icon(
                        LineIcons.clock_o,
                        size: 18,
                        color: txtColor,
                      ),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
        Text(
          Utilities.formatLocalized(
            AppLocalizations.of(context).translate('reasonString'),
            a.motivazione,
          ),
          style: TextStyle(fontSize: 16, color: txtColor,),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            a.calcolo == "0" ?
              AppLocalizations.of(context).translate('contributesNotTo') :
              AppLocalizations.of(context).translate('contributesTo'),
            style: TextStyle(fontSize: 16, color: txtColor,),
          ),
        ),
      ],
    );
  }
}
