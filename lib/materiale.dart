// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

// TODO: pulizia codice materiale

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:mySobrero/common/tiles.dart';
import 'package:mySobrero/ui/data_ui.dart';
import 'package:mySobrero/ui/detail_view.dart';
import 'reapi3.dart';
import 'package:url_launcher/url_launcher.dart';

class MaterialeView extends StatefulWidget {
  reAPI3 apiInstance;
  MaterialeView({Key key, @required this.apiInstance}) : super(key: key);

  @override
  _MaterialeState createState() => _MaterialeState();
}

class _MaterialeState extends State<MaterialeView> with SingleTickerProviderStateMixin {
  Future<List<DocenteStructure>> _materiale;

  @override
  void initState() {
    super.initState();
    _materiale = widget.apiInstance.retrieveMateriale();
  }

  _launchURL(String uri) async {
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SobreroDetailView(
      title: "Materiale Didattico",
      child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            children: <Widget>[
              FutureBuilder<List<DocenteStructure>>(
                future: _materiale,
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
                                child: Text("Sto caricando il materiale...", style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
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
                          emptyStateKey: "noHandouts",
                        );

                      return ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index){
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10, top: 5),
                                child: Text(
                                    snapshot.data[index].docente,
                                    style: TextStyle(
                                        fontSize: 24,
                                    )
                                ),
                              ),
                              ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: snapshot.data[index].cartelle.length,
                                itemBuilder: (ctx, i) => SobreroFlatTile(
                                    margin: EdgeInsets.only(bottom: 15),
                                    overridePadding: true,
                                    children: [ExpandableNotifier(
                                        child: Expandable(
                                          collapsed: ExpandableButton(
                                            child: SobreroFlatTile(
                                              showShadow: false,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets.only(right: 5),
                                                      child: Icon(TablerIcons.folder),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                          snapshot.data[index].cartelle[i].descrizione,
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                          )
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          expanded: Container(
                                            decoration: new BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                            ),
                                            child: Column(
                                              children: <Widget>[
                                                ExpandableButton(
                                                  child: SobreroFlatTile(
                                                    showShadow: false,
                                                    color: Colors.white,
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding: const EdgeInsets.only(right: 5),
                                                            child: Icon(TablerIcons.folder, color: Colors.black),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                                snapshot.data[index].cartelle[i].descrizione,
                                                                style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontWeight:
                                                                    FontWeight.bold,
                                                                    color: Colors.black
                                                                )
                                                            ),
                                                          ),
                                                        ],
                                                      )

                                                    ],
                                                  ),
                                                ),
                                                FutureBuilder<List<FileStructure>>(
                                                    future: widget.apiInstance.retrieveContenutiCartella(snapshot.data[index].id, snapshot.data[index].cartelle[i].idCartella),
                                                    builder: (context, snapshot){
                                                      if (snapshot.hasData){
                                                        return snapshot.data.length > 0 ?ListView.builder(
                                                          primary: false,
                                                          shrinkWrap: true,
                                                          itemCount: snapshot.data.length,
                                                          itemBuilder: (c, i2){
                                                            //return Text(snapshot.data[i2].nome);
                                                            return FlatButton(
                                                                padding: EdgeInsets.zero,
                                                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(15.0),
                                                                  child: Row(
                                                                    children: <Widget>[
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(right: 8.0),
                                                                        child: Icon(TablerIcons.file),
                                                                      ),
                                                                      Expanded(child: Text(snapshot.data[i2].nome,)),
                                                                    ],
                                                                  ),
                                                                ),
                                                                onPressed: (){
                                                                  _launchURL(snapshot.data[i2].url);
                                                                }
                                                            );
                                                          },
                                                        ) : Padding(
                                                          padding: const EdgeInsets.fromLTRB(8.0, 15, 8, 15),
                                                          child: Column(
                                                            children: <Widget>[
                                                              Icon(TablerIcons.cloud, size: 40,),
                                                              Text("La cartella è vuota", style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
                                                            ],
                                                          ),
                                                        );
                                                      } else if (snapshot.hasError) {
                                                        return Padding(
                                                          padding: const EdgeInsets.fromLTRB(8.0, 15, 8, 15),
                                                          child: Column(
                                                            children: <Widget>[
                                                              Icon(Icons.error_outline, size: 40,),
                                                              Text("${snapshot.error}", style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
                                                            ],
                                                          ),
                                                        );
                                                      }
                                                      return Padding(
                                                        padding: const EdgeInsets.all(15.0),
                                                        child: Column(
                                                          children: <Widget>[
                                                            SpinKitDualRing(
                                                              color: Theme.of(context).textTheme.bodyText1.color,
                                                              size: 40,
                                                              lineWidth: 5,
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(top: 15.0),
                                                              child: Text("Sto caricando i contenuti...", style: TextStyle( fontSize: 16), textAlign: TextAlign.center,),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }
                                                )
                                              ],
                                            ),
                                          ),

                                        )
                                    ),],
                                  ),
                              )
                            ],
                          );
                        },
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
