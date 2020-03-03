import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
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

class _ComunicazioniView extends State<ComunicazioniView> with AutomaticKeepAliveClientMixin<ComunicazioniView>{
  @override
  bool get wantKeepAlive => true;

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

  Widget _generaComunicazione(Comunicazioni comunicazione){
    return Container(
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
                      toBeginningOfSentenceCase(comunicazione.titolo),
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                ),
              ]),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(comunicazione.contenuto,
                    style: TextStyle(
                      fontSize: 16,
                    )),
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: generaAllegati(comunicazione.allegati)
              )
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    int columnCount = MediaQuery.of(context).size.width > 550 ? 2 : 1;
    columnCount = MediaQuery.of(context).size.width > 800 ? 3 : columnCount;
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
              //Column(children: generaComunicazioni())
              WaterfallFlow.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: comunicazioni.length,
                itemBuilder: (context, i){
                  return _generaComunicazione(comunicazioni[i]);
                },
                gridDelegate: SliverWaterfallFlowDelegate(
                  crossAxisCount: columnCount,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  lastChildLayoutTypeBuilder: (index) => index == comunicazioni.length
                      ? LastChildLayoutType.foot
                      : LastChildLayoutType.none,
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
