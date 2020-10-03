// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import 'package:mySobrero/reAPI/reapi.dart';
import 'package:mySobrero/reAPI/types.dart';
import 'package:mySobrero/common/utilities.dart';
import 'package:mySobrero/localization/localization.dart';
import 'package:mySobrero/tiles/date_time_tile.dart';
import 'package:mySobrero/ui/data_ui.dart';
import 'package:mySobrero/ui/detail_view.dart';
import 'package:mySobrero/ui/helper.dart';

// TODO: pulizia codice assenze

class AssenzeView extends StatefulWidget {

  AssenzeView({Key key}) : super(key: key);
  @override
  _AssenzeState createState() => _AssenzeState();
}

class _AssenzeState extends State<AssenzeView> {

  @override
  void initState() {
    super.initState();
    _assenze = reAPI4.instance.getAbsences();
  }

  Future<OverallAbsences> _assenze;

  @override
  Widget build(BuildContext context) {
    return SobreroDetailView(
      title: AppLocalizations.of(context).translate('absences'),
      child: FutureBuilder<OverallAbsences>(
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
                if (snapshot.data.justified.isEmpty
                & snapshot.data.wo_justification.isEmpty)
                  return SobreroEmptyState(
                    emptyStateKey: "noAbsences",
                  );
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (snapshot.data.wo_justification.length > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 15),
                          child: Text(
                            AppLocalizations.of(context).translate('notJustified'),
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          ),
                        ),
                      if (snapshot.data.wo_justification.length > 0)
                        WaterfallFlow.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: snapshot.data.wo_justification.length,
                          itemBuilder: (_, i) => _displayAbsence(
                            snapshot.data.wo_justification[i],
                            true,
                          ),
                          gridDelegate: SliverWaterfallFlowDelegate(
                            crossAxisCount: UIHelper.columnCount(context),
                            mainAxisSpacing: 15.0,
                            crossAxisSpacing: 15.0,
                            lastChildLayoutTypeBuilder: (i) =>
                            i == snapshot.data.wo_justification.length ? LastChildLayoutType.foot
                                : LastChildLayoutType.none,
                          ),
                        ),
                      if (snapshot.data.justified.length > 0)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Text(
                            AppLocalizations.of(context).translate(
                              'absencesWithJustification',
                            ),
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      if (snapshot.data.justified.length > 0)
                        WaterfallFlow.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: snapshot.data.justified.length,
                        itemBuilder: (_, i) => _displayAbsence(
                          snapshot.data.justified[i],
                          false,
                        ),
                        gridDelegate: SliverWaterfallFlowDelegate(
                          crossAxisCount: UIHelper.columnCount(context),
                          mainAxisSpacing: 15.0,
                          crossAxisSpacing: 15.0,
                          lastChildLayoutTypeBuilder: (i) =>
                          i == snapshot.data.justified.length ? LastChildLayoutType.foot
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

  Widget _displayAbsence(Absence a, bool notJustified) {
    Color txtColor = notJustified ? Colors.white : null;

    String typeID = AppLocalizations.of(context).translate('absence');
    if (a.type == "Ritardo")
      typeID = AppLocalizations.of(context).translate('delay');
    if (a.type == "Uscita")
      typeID = AppLocalizations.of(context).translate('earlyCK');
    return DateTimeTile(
      title: typeID,
      date: "${a.date} ${a.hour ?? "00:00:00"}",
      color: notJustified ? Colors.red : null,
      margin: EdgeInsets.zero,
      showHour: a.type != "Assenza",
      children: [
        Text(
          Utilities.formatArgumentString(
            AppLocalizations.of(context).translate('reasonString'),
            arg: a.reason.length > 0
                ? a.reason
                : AppLocalizations.of(context).translate('NOT_DEFINED'),
          ),
          style: TextStyle(
            fontSize: 16,
            color: txtColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            a.contributes == "0" ?
            AppLocalizations.of(context).translate('contributesNotTo') :
            AppLocalizations.of(context).translate('contributesTo'),
            style: TextStyle(
              fontSize: 16,
              color: txtColor,
            ),
          ),
        ),
      ],
    );
  }
}
