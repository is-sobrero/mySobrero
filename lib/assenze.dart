// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mySobrero/common/tiles.dart';
import 'package:mySobrero/reapi3.dart';
import 'package:mySobrero/ui/detail_view.dart';

// TODO: pulizia codice assenze

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

  @override
  void dispose() {
    super.dispose();
  }

  Future<AssenzeStructure> _assenze;

  @override
  Widget build(BuildContext context) {
    return SobreroDetailView(
      title: "Assenze",
      child: FutureBuilder<AssenzeStructure>(
          future: _assenze,
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
                          child: Text("Sto caricando le assenze...", style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
                        ),
                      ],
                    ),
                  ),
                );
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 15, 8, 15),
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.warning, size: 40,),
                        Text("${snapshot.error}", style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
                      ],
                    ),
                  );
                }
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0, top: 20),
                        child: Text(
                          "Non giustificate",
                          style: TextStyle(
                              fontSize: 24,),
                        ),
                      ),
                      Column(
                        children: snapshot.data.nongiustificate.length > 0 ? generaAssenze(
                            snapshot.data.nongiustificate,
                            true, context) : <Widget>[Text("Nessuna assenza da giustificare, ottimo!", textAlign: TextAlign.center,)
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Text(
                          snapshot.data.giustificate.length > 25 ? "Ultime 25 giustificate" : "Giustificate",
                          style: TextStyle(fontSize: 24, ),
                        ),
                      ),
                      Column(
                        children: generaAssenze(
                            snapshot.data.giustificate.length > 25 ? snapshot.data.giustificate.sublist(0, 24) : snapshot.data.giustificate,
                            false,
                            context),
                      ),
                    ]
                );
            }
            return null;
          }
      ),
    );
  }

  List<Widget> generaAssenze(List<AssenzaStructure> assenze, bool nonGiustificate, BuildContext context) {
    List<Widget> list = new List<Widget>();
    assenze.forEach((a) {
      Color txtColor = nonGiustificate ? Colors.white : null;
      list.add(GenericTile(
        margin: EdgeInsets.only(bottom: 15),
        color: nonGiustificate ? Colors.red : null,
        children: [
          Text(
            a.tipologia == "Assenza"
                ? "Assenza del ${a.data}"
                : "${a.tipologia} alle ore ${a.orario} del ${a.data}",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: txtColor,
            ),),
          Text("Motivazione: ${a.motivazione}",
              style: TextStyle(fontSize: 16, color: txtColor)),
          Text("Concorre al calcolo: ${a.calcolo == "0" ? "No" : "Sì"}",
              style: TextStyle(fontSize: 16, color: txtColor)),
        ],
      ));
    });
    return list;
  }
}
