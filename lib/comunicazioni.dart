import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'reapi2.dart';
import 'package:url_launcher/url_launcher.dart';


class ComunicazioniView extends StatefulWidget {
  List<Comunicazioni> comunicazioni;

  ComunicazioniView(List<Comunicazioni> comunicazioni) {
    this.comunicazioni = comunicazioni;
  }
  @override
  _ComunicazioniView createState() => _ComunicazioniView(comunicazioni);
}

class _ComunicazioniView extends State<ComunicazioniView> {
  List<Comunicazioni> comunicazioni;
  _ComunicazioniView(List<Comunicazioni> comunicazioni) {
    this.comunicazioni = comunicazioni;
  }

  _launchURL(String uri) async {
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }


  List<Widget> generaAllegati(List<Allegato> allegati){
    List<Widget> list = new List<Widget>();
    for (int i = 0; i<allegati.length; i++){
      list.add(ActionChip(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          _launchURL(allegati[i].url);
        },
        avatar: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Icon(Icons.attach_file, color: Colors.white, size: 20),
        ),
        label: Text(allegati[i].nome, style: TextStyle(color: Colors.white),),
      ));
    }
    return list;
  }

  List<Widget> generaComunicazioni() {
    List<Widget> list = new List<Widget>();
    for (int i = 0; i < comunicazioni.length; i++) {
      list.add(Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Container(
            decoration: new BoxDecoration(
                color: Theme.of(context).textTheme.body1.color.withAlpha(20),
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(width: 1.0, color: Color(0xFFCCCCCC))),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Wrap(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                          toBeginningOfSentenceCase(comunicazioni[i].titolo),
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                    ),
                    /*Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(14.0, 5.0, 14.0, 5.0),
                          child: Text(comunicazioni[i].mittente,
                              style: TextStyle(color: Colors.white)),
                        )),*/
                  ]),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(comunicazioni[i].contenuto,
                        style: TextStyle(
                          fontSize: 16,
                        )),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: generaAllegati(comunicazioni[i].allegati)
                  )
                ],
              ),
            )),
      ));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
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
              Column(children: generaComunicazioni())
            ],
          ),
        ),
      ],
    ));
  }
}
