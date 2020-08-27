// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import 'package:mySobrero/common/utilities.dart';
import 'package:mySobrero/localization/localization.dart';
import 'package:mySobrero/reapi3.dart';
import 'package:mySobrero/tiles/date_time_tile.dart';
import 'package:mySobrero/ui/data_ui.dart';
import 'package:mySobrero/ui/detail_view.dart';
import 'package:mySobrero/ui/helper.dart';

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
                if (snapshot.data.giustificate.isEmpty & snapshot.data.nongiustificate.isEmpty)
                  return SobreroEmptyState(
                    emptyStateKey: "noAbsences",
                  );
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (snapshot.data.nongiustificate.length > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 15),
                          child: Text(
                            AppLocalizations.of(context).translate('notJustified'),
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          ),
                        ),
                      if (snapshot.data.nongiustificate.length > 0)
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
                        ),
                      if (snapshot.data.giustificate.length > 0)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Text(
                            AppLocalizations.of(context).translate(
                              'absencesWithJustification',
                            ),
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      if (snapshot.data.giustificate.length > 0)
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
    return DateTimeTile(
      title: typeID,
      date: "${a.data} ${a.orario ?? "00:00:00"}",
      color: notJustified ? Colors.red : null,
      margin: EdgeInsets.zero,
      children: [
        Text(
          Utilities.formatLocalized(
            AppLocalizations.of(context).translate('reasonString'),
            a.motivazione,
          ),
          style: TextStyle(
            fontSize: 16,
            color: txtColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            a.calcolo == "0" ?
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
