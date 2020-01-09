import 'package:flutter/material.dart';
import 'reapi.dart';

class AssenzeView extends StatelessWidget {
  Assenze assenze;

  AssenzeView(Assenze assenze) {
    this.assenze = assenze;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assenze"),
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
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Text(
                  "Assenze non giustificate",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
              Column(
                children: generaComunicazioni(assenze.nongiustificate, context),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Text(
                  "Assenze giustificate",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
              Column(
                children: generaComunicazioni(assenze.giustificate, context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> generaComunicazioni(List<Nongiustificate> assenze, BuildContext context) {
    List<Widget> list = new List<Widget>();
    for (int i = 0; i < assenze.length; i++) {
      final String tipologia = assenze[i].tipologia;
      final String orario = assenze[i].orario;
      final String data = assenze[i].data;
      final String motivazione = assenze[i].motivazione;
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
                          tipologia == "Assenza"
                              ? "Assenza del $data"
                              : "$tipologia alle ore $orario del $data",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)
                      ),
                      Text(
                          "Motivazione: $motivazione",
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
}
