// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

// TODO: pulizia codice ricerca aule

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mySobrero/common/tiles.dart';
import 'package:mySobrero/common/ui.dart';
import 'package:mySobrero/ui/detail_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';

class RicercaAuleView extends StatefulWidget {

  RicercaAuleView({Key key}) : super(key: key);

  @override
  _RicercaAuleState createState() => _RicercaAuleState();
}

class Aula {
  String id;
  String locale;
  String denominazione;
  bool computer;
  bool ethernet;
  bool prese;
  String piano;
  String plesso;

  Aula.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    locale = json['locale'];
    denominazione = json['denominazione'];
    computer = json['computer'];
    ethernet = json['ethernet'];
    prese = json['prese'];
    piano = json['piano'];
    plesso = json['plesso'];
  }
}

class _RicercaAuleState extends State<RicercaAuleView> {
  Future<List<Aula>> _ottieniAule(String query, int filter) async {
    final endpointCartella = 'https://reapistaging.altervista.org/api/v3/searchAule?params=$filter&q=${Uri.encodeComponent(query)}';
    Map<String, String> headers = {
      'Accept': 'application/json',
    };
    final response = await http.get(endpointCartella, headers: headers);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)["results"];
      return jsonResponse.map((aula) => new Aula.fromJson(aula)).toList();
    } else {
      throw Exception('Impossibile ricercare le aule (${json.decode(response.body)["status"]["description"]})');
    }
  }

  int filterIndex = 0;

  Future<List<Aula>> _risultatoAule;
  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SobreroDetailView(
      title: "Ricerca aule",
      child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SobreroTextField(
                hintText: "Aula da cercare",
                controller: _searchController,
                suffixIcon: IconButton(
                  icon: Icon(LineIcons.search),
                  color: Theme.of(context).primaryColor,
                  onPressed: () => setState(() {
                    _risultatoAule = _ottieniAule(
                        _searchController.text,
                        filterIndex
                    );
                  }),
                ),
              ),
              FutureBuilder<List<Aula>>(
                  future: _risultatoAule,
                  builder: (context, snapshot){
                    switch (snapshot.connectionState){
                      case ConnectionState.none:
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 15, 8, 15),
                            child: Column(
                              children: <Widget>[
                                Icon(LineIcons.search, size: 40,),
                                Text("Premi il tasto di ricerca per iniziare", style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
                              ],
                            ),
                          ),
                        );
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
                                  child: Text("Sto cercando le aule...", style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
                                ),
                              ],
                            ),
                          ),
                        );
                      case ConnectionState.done:
                        if (snapshot.hasData)
                          return snapshot.data.length > 0 ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  "Risultati ricerca (${snapshot.data.length} aule trovate)",
                                  style: TextStyle(
                                      fontSize: 24,
                                      ),
                                ),
                              ),
                              ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                itemBuilder: (c, i2){
                                  IconData descriptiveIcon = snapshot.data[i2].denominazione.contains("Lab") ? LineIcons.gear : LineIcons.building_o;
                                  descriptiveIcon = snapshot.data[i2].denominazione.contains("Palestra") ? Icons.directions_run : descriptiveIcon;
                                  return ExpandableNotifier(
                                    child: SobreroFlatTile(
                                      overridePadding: true,
                                      margin: EdgeInsets.only(bottom: 15),
                                      children: <Widget>[
                                        Expandable(
                                          collapsed: ExpandableButton(
                                            child: SobreroFlatTile(
                                              showShadow: false,
                                              children: [
                                                Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets.only(right: 5),
                                                      child: Icon(descriptiveIcon),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                          snapshot.data[i2].denominazione,
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
                                          expanded: SobreroFlatTile(
                                            showShadow: false,
                                            overridePadding: true,
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
                                                          child: Icon(descriptiveIcon, color: Colors.black,),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                              snapshot.data[i2].denominazione,
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                  FontWeight.bold,
                                                                  color: Colors.black
                                                              )
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                                                      child: Center(
                                                        child: SvgPicture.network(
                                                          'http://reapistaging.altervista.org/api/v3/getMappa?aula=${snapshot.data[i2].locale}&piano=${snapshot.data[i2].locale.substring(0,0)}',
                                                          fit: BoxFit.contain,
                                                          height: 120,
                                                          placeholderBuilder: (BuildContext context) => Container(
                                                            padding: const EdgeInsets.all(30.0),
                                                            child: Center(
                                                              child: Column(
                                                                children: <Widget>[
                                                                  SpinKitDualRing(
                                                                    color: Colors.black,
                                                                    size: 40,
                                                                    lineWidth: 5,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(top: 8.0),
                                                                    child: Text("Sto caricando la mappa...", style: TextStyle(color: Colors.black, fontSize: 16), textAlign: TextAlign.center,),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(15),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text("Piano aula: ${snapshot.data[i2].piano}",),
                                                    Text("Locale aula: ${snapshot.data[i2].locale}",),
                                                    Text(
                                                        ("Aula dotata di " + (snapshot.data[i2].prese ? "prese, " : "") +
                                                            (snapshot.data[i2].ethernet ? "attacchi ethernet, " : "") +
                                                            (snapshot.data[i2].computer ? "computer, " : "")),
                                                    ),
                                                    Text("Plesso: ${snapshot.data[i2].plesso}", ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ) : Center(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 15, 8, 15),
                              child: Column(
                                children: <Widget>[
                                  Icon(Icons.cloud_queue, size: 40,),
                                  Text("Nessuna aula che rispetti i criteri trovata", style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
                                ],
                              ),
                            ),
                          );
                        if (snapshot.hasError)
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 15, 8, 15),
                              child: Column(
                                children: <Widget>[
                                  Icon(Icons.error_outline, size: 40,),
                                  Text("${snapshot.error}", style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
                                ],
                              ),
                            ),
                          );
                    }
                    return null;
                  }
              )
            ],
          ))
    );

  }
}
