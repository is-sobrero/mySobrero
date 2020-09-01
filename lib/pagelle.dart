// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

// TODO: pulizia codice pagelle

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mySobrero/common/tiles.dart';
import 'package:mySobrero/reapi3.dart';
import 'package:mySobrero/ui/data_ui.dart';
import 'package:mySobrero/ui/detail_view.dart';
import 'package:mySobrero/ui/toggle.dart';

class PagelleView extends StatefulWidget {
  reAPI3 apiInstance;

  PagelleView({Key key, @required this.apiInstance}) : super(key: key);

  @override
  _PagelleState createState() => _PagelleState();
}

class _PagelleState extends State<PagelleView> {

  List<String> materie;

  @override
  void initState() {
    super.initState();
    _pagelle = widget.apiInstance.retrievePagelle();
  }

  int selezionaPagella = 0;

  Future<List<PagellaStructure>> _pagelle;

  PagellaStructure selectedPagella;

  int filterIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SobreroDetailView(
      title: "Pagelle",
      child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            children: <Widget>[
              SobreroToggle(
                margin: EdgeInsets.only(bottom: 15),
                values: ["1° Periodo", "2° Periodo"],
                onToggleCallback: (val) => setState(() => selezionaPagella = val),
                selectedItem: selezionaPagella,
                width: 200,
              ),
              FutureBuilder<List<PagellaStructure>>(
                future: _pagelle,
                builder: (context, snapshot){
                  switch (snapshot.connectionState){
                    case ConnectionState.none:
                    case ConnectionState.active:
                    case ConnectionState.waiting:
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              SpinKitDualRing(
                                color: Theme.of(context).textTheme.bodyText1.color,
                                size: 40,
                                lineWidth: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text("Sto caricando le pagelle", style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
                              ),
                            ],
                          ),
                        ),
                      );
                    case ConnectionState.done:
                      if (snapshot.hasError)
                        return SobreroError(
                          snapshotError: snapshot.error,
                        );
                      if (snapshot.data.isEmpty)
                        return SobreroEmptyState(
                          emptyStateKey: "noReports",
                        );
                      if (selezionaPagella == snapshot.data.length) selectedPagella = null;
                      else selectedPagella = snapshot.data[selezionaPagella];
                      if (selectedPagella == null)
                        return SobreroEmptyState(
                          emptyStateKey: "noReports",
                        );
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Media pagella",),
                          Text(
                            selectedPagella.media.toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              selectedPagella.esito != "" ?  selectedPagella.esito  : "Esito non specificato",
                              style: TextStyle(fontSize: 20,),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: selectedPagella.materie.length,
                            itemBuilder: (context, index) {
                              VotoFinaleStructure mat = selectedPagella.materie.values.elementAt(index);
                              String materia = selectedPagella.materie.keys.elementAt(index);
                              return SobreroFlatTile(
                                margin: EdgeInsets.only(bottom: 15),
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(right: 15),
                                        child: Text(mat.voto.toString(), style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,)),
                                      ),
                                      Expanded(child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(materia, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,)),
                                          Text("Ore di assenza: ${mat.assenze}",
                                              style: TextStyle(
                                                fontSize: 16,
                                              )),
                                        ],
                                      ))
                                    ],
                                  ),
                                ],
                              );
                            },
                          )
                        ],
                      );
                  }
                  return null;
                },
              )
            ],
          )),
    );
  }
}
