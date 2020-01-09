import 'package:flutter/material.dart';
import 'reapi.dart';
import 'package:expandable/expandable.dart';

class ComunicazioniView extends StatefulWidget {
  List<Comunicazioni> comunicazioni;

  ComunicazioniView( List<Comunicazioni> comunicazioni){
    this.comunicazioni = comunicazioni;
  }
  @override
  _ComunicazioniView createState() => _ComunicazioniView(comunicazioni);
}

class _ComunicazioniView extends State<ComunicazioniView> {
  List<Comunicazioni> comunicazioni;
  _ComunicazioniView(List<Comunicazioni> comunicazioni){
    this.comunicazioni = comunicazioni;
  }

  List<Widget> generaComunicazioni() {
    List<Widget> list = new List<Widget>();
    for (int i = 0; i < comunicazioni.length; i++){
      list.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Container(
                decoration: new BoxDecoration(
                    color: Theme.of(context).textTheme.body1.color.withAlpha(20),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(width: 1.0, color: Color(0xFFCCCCCC))
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,

                    children: <Widget>[
                      Text(
                          comunicazioni[i].mittente,
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
                      ),
                      Text(
                          comunicazioni[i].contenuto,
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Tutte le comunicazioni',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Column(
                    children: generaComunicazioni()
                  )
                ],
              ),
            ),
          ],
        )
    );
  }
}