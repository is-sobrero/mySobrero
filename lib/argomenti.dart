// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:mySobrero/common/tiles.dart';
import 'package:mySobrero/custom/dropdown.dart';
import 'package:mySobrero/reAPI/reapi.dart';
import 'package:mySobrero/reAPI/types.dart';
import 'package:mySobrero/ui/data_ui.dart';
import 'package:mySobrero/ui/detail_view.dart';
import 'package:mySobrero/ui/dropdown.dart';
import 'package:mySobrero/ui/toggle.dart';

// TODO: pulizia codice argomenti

class ArgomentiView extends StatefulWidget {

  ArgomentiView({Key key}) : super(key: key);

  @override
  _ArgomentiState createState() => _ArgomentiState();
}

class _ArgomentiState extends State<ArgomentiView> {
  List<Topic> regclasse;

  List<String> materie;
  List<Topic> argSettimana;
  Future<List<Topic>> _argomenti;

  @override
  void initState() {
    super.initState();
    _argomenti = reAPI4.instance.getTopics();
    _argomenti.then((topics){
      this.argSettimana = List<Topic>();
      for (int i = 0; i < topics.length; i++) {
        var currentGiorno = formatter.parse(topics[i].date.split(" ")[0]);
        if (currentGiorno.compareTo(inizioSettimana) >= 0){
          this.argSettimana.add(topics[i]);
          print("Futuri argomenti: ${formatter.format(currentGiorno)}");
        }
        materie = new List();
        materie.add("Tutte le materie");
        for (int i = 0; i < topics.length; i++) {
          String m = topics[i].subject;
          if (!materie.contains(m)) materie.add(m);
        }
      }
      return _argomenti;
    });

    inizioSettimana = today.subtract(new Duration(days: today.weekday - 1));
    formatter = new DateFormat('dd/MM/yyyy');
  }

  DateTime today = DateTime.now();
  var inizioSettimana, formatter;


  int selezioneArgomenti = 0;

  @override
  Widget build(BuildContext context) {
    String dataTemporanea = "";
    return SobreroDetailView(
      title: "Argomenti",
      child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: FutureBuilder<List<Topic>>(
            future: _argomenti,
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
                            child: Text("Sto caricando gli argomenti", style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
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
                      emptyStateKey: "noTopics",
                    );
                  List<Topic> currentSet = selezioneArgomenti == 0 ? argSettimana : snapshot.data.reversed.toList();
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: SobreroToggle(
                          values: ["Settimana", "Tutti"],
                          onToggleCallback: (val) => setState(() => selezioneArgomenti = val),
                          selectedItem: selezioneArgomenti,
                          width: 200,
                        ),
                      ),
                      Column(
                        children: [
                          SobreroDropdown(
                            margin: EdgeInsets.only(bottom: 20),
                            value: materie[filterIndex],
                            onChanged: (String value) {
                              filterIndex = materie.indexOf(value);
                              setState(() {});
                            },
                            items: materie.map((String user) {
                              return CustomDropdownMenuItem<String>(
                                value: user,
                                child: Text(
                                  user,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      ListView.builder(
                        addAutomaticKeepAlives: true,
                        primary: false,
                        shrinkWrap: true,
                        itemCount: currentSet.length,
                        itemBuilder: (context, index){
                          var mesi = ["Gennaio", "Febbraio", "Marzo", "Aprile",
                            "Maggio", "Giugno", "Luglio", "Agosto", "Settembre",
                            "Ottobre", "Novembre", "Dicembre"];
                          var tempString = currentSet[index].date.split(" ")[0].split("/");
                          String formattedDate = "${tempString[0]} ${mesi[int.parse(tempString[1]) - 1]}";
                          bool mostraGiornata = true;
                          final bool mostra = filterIndex == 0 ? true : currentSet[index].subject == materie[filterIndex];
                          if (dataTemporanea != currentSet[index].date){
                            dataTemporanea = currentSet[index].date;
                            if (filterIndex != 0){
                              mostraGiornata = false;
                              print("filtro giornate attivo");
                              for (int i = 0; i < currentSet.length; i++) {
                                if (currentSet[i].subject == materie[filterIndex] && currentSet[i].date == dataTemporanea) {
                                  mostraGiornata = true;
                                  break;
                                }
                              }
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                if (mostraGiornata) Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: Text(
                                    formattedDate,
                                    style: TextStyle(
                                        fontSize: 24,
                                    ),
                                  ),
                                ),
                                if (mostra) SobreroFlatTile(
                                  margin: EdgeInsets.only(bottom: 15),
                                  children: [
                                    Text(currentSet[index].subject,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight:
                                            FontWeight.bold,
                                            )
                                    ),
                                    Text(
                                        currentSet[index].description.trim(),
                                        style: TextStyle(fontSize: 16)
                                    ),
                                  ]
                                )
                              ],
                            );
                          }
                          dataTemporanea = currentSet[index].date;
                          return mostra ? SobreroFlatTile(
                            margin: EdgeInsets.only(bottom: 15),
                              children: [
                                Text(currentSet[index].subject,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                      FontWeight.bold,
                                    )
                                ),
                                Text(
                                    currentSet[index].description.trim(),
                                    style: TextStyle(fontSize: 16)
                                ),
                              ]
                          ) : Container();
                        },
                      )
                    ],
                  );
              }
              return null;
            },
          )
      ),
    );
  }

  int filterIndex = 0;
}
