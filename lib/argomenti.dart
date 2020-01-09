import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';


import 'package:flutter/material.dart';
import 'reapi.dart';

class ArgomentiView extends StatelessWidget {
  List<Regclasse> regclasse;
  ArgomentiView(List<Regclasse> regclasse) {
    this.regclasse = regclasse;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Argomenti della settimana"),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        textTheme: Theme.of(context).textTheme,
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: generaGiornate(context)
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> generaArgomenti(List<Argomento> argomenti, BuildContext context) {
    List<Widget> list = new List<Widget>();
    for (int i = 0; i < argomenti.length; i++){
      list.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Container(
                decoration: new BoxDecoration(
                    color: Theme
                        .of(context)
                        .textTheme
                        .body1
                        .color
                        .withAlpha(20),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(width: 1.0, color: Color(0xFFCCCCCC))
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,

                    children: <Widget>[
                      Text(
                          argomenti[i].materia,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)
                      ),
                      Text(
                          argomenti[i].descrizione,
                          style: TextStyle(fontSize: 16,)
                      )
                    ],
                  ),
                )
            ),
          )
      );
    }
    return list;
  }

  List<Widget> generaGiornate(BuildContext context) {
    initializeDateFormatting('it');
    List<Widget> list = new List<Widget>();
    for (int i = 0; i < regclasse.length; i++) {
      LineSplitter l = new LineSplitter();
      DateFormat format = new DateFormat("DD/MM/yyyy");
      var parsedDate = format.parse(l.convert(regclasse[i].data)[0]);
      String formattedDate = DateFormat('DD MMMM', 'it').format(parsedDate);
      list.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              formattedDate,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          )
      );
      list += generaArgomenti(regclasse[i].argomenti, context);
    }
    return list;
  }


}
