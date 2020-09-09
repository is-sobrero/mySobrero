import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mySobrero/cloud_connector/cloud2.dart';
import 'package:mySobrero/common/pageswitcher.dart';
import 'package:mySobrero/common/tiles.dart';
import 'package:mySobrero/common/ui.dart';
import 'package:mySobrero/localization/localization.dart';
import 'package:mySobrero/reapi3.dart';
import 'package:mySobrero/ui/data_ui.dart';
import 'package:mySobrero/ui/detail_view.dart';
import 'package:mySobrero/ui/helper.dart';
import 'package:mySobrero/ui/toggle.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:mySobrero/ui/hud.dart';
import 'package:mySobrero/common/definitions.dart';

class DialogoObbiettivo extends StatefulWidget {
  String materia;
  Function(int) nuovoObbiettivoCallback;
  int initialVoto = 6;

  DialogoObbiettivo({Key key, @required this.materia, @required this.nuovoObbiettivoCallback, @required this.initialVoto}) : super(key: key);

  @override
  _dObbiettivoState createState() => _dObbiettivoState();
}

class _dObbiettivoState extends State<DialogoObbiettivo> {
  final List<Color> sufficienza = <Color>[Color(0xff23b6e6), Color(0xff02d39a)];
  final List<Color> limite = <Color>[Color(0xffFFD200), Color(0xffF7971E)];
  final List<Color> insufficienza = <Color>[Color(0xffFF416C), Color(0xffFF4B2B)];

  int voto = 0;

  @override
  void initState(){
    super.initState();
    voto = widget.initialVoto;
  }

  @override
  Widget build(BuildContext context){
    if (voto < 1) voto = 1;
    if (voto > 10) voto = 10;
    List<Color> selezionato = sufficienza;
    if (voto < 7) selezionato = limite;
    if (voto < 6) selezionato = insufficienza;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[
                    AutoSizeText(
                      "Imposta obbiettivo per ${widget.materia}",
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.remove),
                          color: Theme.of(context).primaryColor,
                          onPressed: (){
                            setState(() {
                              voto--;
                            });
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularPercentIndicator(
                            radius: 75,
                            lineWidth: 8,
                            percent: voto / 10,
                            animation: true,
                            animationDuration: 300,
                            animateFromLastPercent: true,
                            circularStrokeCap: CircularStrokeCap.round,
                            center: Container(
                                width: 50,
                                child: AutoSizeText(
                                  voto.toString(),
                                  minFontSize: 8,
                                  maxLines: 1,
                                  style: TextStyle(fontSize: 25, ),
                                  textAlign: TextAlign.center,
                                )
                            ),
                            backgroundColor: Colors.black26,
                            linearGradient: LinearGradient(
                                colors: selezionato
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          color: Theme.of(context).primaryColor,
                          onPressed: (){
                            setState(() {
                              voto++;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              OutlineButton(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.nuovoObbiettivoCallback(voto);
                },
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(7.0))),
                color: Theme.of(context).primaryColor,
                child: const Text(
                  'IMPOSTA OBBIETTIVO',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SituazioneView extends StatefulWidget {
  Map<String, SituazioneElement> situazione1Q, situazione2Q;
  Map<String, int> obbiettivi;
  Function(Map<String, int>) onObbiettiviChange;
  reAPI3 apiInstance;

  SituazioneView({Key key, @required this.situazione1Q, @required this.situazione2Q, @required this.obbiettivi, @required this.onObbiettiviChange, @required this.apiInstance}) : super(key: key);

  @override
  _SituazioneView createState() => _SituazioneView();
}

class SituaMateria{
  String materia;
  double media;
  SituaMateria(String materia, double media){
    this.materia = materia;
    this.media = media;
  }
}

class _SituazioneView extends State<SituazioneView> {
  Future<List<PagellaStructure>> _pagelle;

  int selezionePeriodo = 0;

  @override
  void initState() {
    super.initState();
    obbiettivi = widget.obbiettivi;
    _pagelle = widget.apiInstance.retrievePagelle();
  }

  final sogliaArrotondamento = 0.6;

  Map <String, int> obbiettivi = Map<String, int>();

  Widget _templateVoto(String materia, double voto, int numVoti){
    List<Color> selezionato = AppColorScheme.greenGradient;
    if (voto < 7) selezionato = AppColorScheme.yellowGradient;
    if (voto < 6) selezionato = AppColorScheme.redGradient;

    bool esisteObbiettivo = obbiettivi.containsKey(materia);

    return Padding(
      padding: const EdgeInsets.only(top: 7.5, bottom: 7.5),
      child: Row(
        children: <Widget>[
          new CircularPercentIndicator(
            radius: 75,
            lineWidth: 8,
            percent: voto/10,
            animation: true,
            animationDuration: 1200,
            circularStrokeCap: CircularStrokeCap.round,
            center: Container(
                width: 50,
                child: AutoSizeText(
                  voto.toStringAsFixed(1),
                  minFontSize: 8,
                  maxLines: 1,
                  style: TextStyle(fontSize: 25, ),
                  textAlign: TextAlign.center,
                )
            ),
            backgroundColor: Theme.of(context).textTheme.bodyText1
                .color.withOpacity(0.1),
            linearGradient: LinearGradient(
              colors: selezionato
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(materia, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  esisteObbiettivo ?
                    Text(ottieniVotiXMedia(voto, numVoti, obbiettivi[materia])) : Text("Tocca per impostare obbiettivo")
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Dialog cambiaObbiettivo(String materia, int setpointObbiettivo){
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), //this right here
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 200),
        child: DialogoObbiettivo(
          materia: materia,
          initialVoto: setpointObbiettivo,
          nuovoObbiettivoCallback: (obbiettivo){
            setState(() {
              obbiettivi[materia] = obbiettivo;
              widget.onObbiettiviChange(obbiettivi);
            });
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context){
                return dialogoHUD(future: aggiornaObbiettivi(jsonEncode(obbiettivi)), titolo: "Aggiornamento obbiettivi in corso...",);
              }
            );
            //aggiornaObbiettivi(jsonEncode(obbiettivi));
          },
        ),
      ),
    );
  }

  Future<bool> aggiornaObbiettivi (g) async => CloudConnector.setGoals(
    token: widget.apiInstance.getSession(),
    goals: g,
  );

  String ottieniVotiXMedia(double mediaAttuale, int countVoti, int obbiettivo){
    int volte = 0;
    double finalVoto = -1;
    do {
      volte++;
      double sogliaMinima = obbiettivo - (1 - sogliaArrotondamento);
      finalVoto = sogliaMinima * (countVoti + volte) - mediaAttuale * countVoti;
      finalVoto /= volte.toDouble();
    } while ((finalVoto < 1 || finalVoto > 10) && volte < 10);

    if (volte == 10){
      return "Impossibile raggiungere l'obbiettivo stabilito matematicamente";
    }

    String fineFrase = volte == 1 ? "a" : "e";
    if (mediaAttuale >= obbiettivo){
      return "Non prendere per $volte volt$fineFrase meno di ${finalVoto.toStringAsFixed(2)} per mantenere la media superiore a $obbiettivo";
    } else {
      return "Prendi per $volte volt$fineFrase almeno ${finalVoto.toStringAsFixed(2)} per avere $obbiettivo di media";
    }
  }

  Widget _generaPrevisione(double mediaAttuale, int mediaPrevista, double media1Q, double scarto, String materia){
    var scartoGrad = AppColorScheme.blueGradient;
    var mediaGrad = AppColorScheme.greenGradient;
    Color mediaColor = Colors.green;
    if (scarto > 0) scartoGrad = AppColorScheme.greenGradient;
    if (scarto < 0) scartoGrad = AppColorScheme.redGradient;
    if (media1Q < 6) mediaGrad = AppColorScheme.redGradient;
    return SobreroFlatTile(
      children: [
        Text(
          materia,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5, right: 8, bottom: 5),
              child: Text(
                "Media prevista: ${mediaPrevista}",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text("Voto in pagella 1Q", textAlign: TextAlign.center),
                    Container(
                      margin: EdgeInsets.only(top: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(30),
                            blurRadius: 10,
                            spreadRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: mediaGrad,
                        ),
                      ),
                      child: CircleAvatar(
                        child: Text(
                          media1Q.toStringAsFixed(1),
                          style: TextStyle(
                            color: UIHelper.textColorByBackground(mediaGrad[0]),
                            fontSize: 20,
                          ),
                        ),
                        backgroundColor: Colors.transparent,
                        radius: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "Scarto rispetto alla media",
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(30),
                            blurRadius: 10,
                            spreadRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: scartoGrad,
                        ),
                      ),
                      child: CircleAvatar(
                        child: Text(
                          scarto.toStringAsFixed(1),
                          style: TextStyle(
                            color: UIHelper.textColorByBackground(scartoGrad[0]),
                            fontSize: 20,
                          ),
                        ),
                        backgroundColor: Colors.transparent,
                        radius: 30,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  bool _reverseAnim = false;

  @override
  Widget build(BuildContext context) {
    final Map<String, SituazioneElement> currentPeriodo = selezionePeriodo == 0 ? widget.situazione1Q : widget.situazione2Q;
    return SobreroDetailView(
      title: "Situazione attuale",
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                children: <Widget>[
                  SobreroToggle(
                    values: [
                      AppLocalizations.of(context).translate("firstPeriod"),
                      AppLocalizations.of(context).translate("secondPeriod"),
                      "Previsioni" //  AppLocalizations.of(context).translate("forecast"),
                    ],
                    onToggleCallback: (c) => setState(() {
                      _reverseAnim = c < selezionePeriodo;
                      selezionePeriodo = c;
                    }),
                    selectedItem: selezionePeriodo,
                    width: 300,
                    margin: EdgeInsets.only(bottom: 10),
                  ),
                  PageTransitionSwitcher2(
                    reverse: _reverseAnim,
                    layoutBuilder: (_entries) => Stack(
                      children: _entries
                          .map<Widget>((entry) => entry.transition)
                          .toList(),
                      alignment: Alignment.topLeft,
                    ),
                    duration: Duration(milliseconds: UIHelper.pageAnimDuration),
                    transitionBuilder: (c, p, s) => SharedAxisTransition(
                      fillColor: Colors.transparent,
                      animation: p,
                      secondaryAnimation: s,
                      transitionType: SharedAxisTransitionType.horizontal,
                      child: c,
                    ),
                    child: selezionePeriodo != 2 ? ListView.builder(
                        key: ValueKey<int>(selezionePeriodo),
                        primary: false,
                        shrinkWrap: true,
                        itemCount: currentPeriodo.values.length,
                        itemBuilder: (context, index){
                          String materia = currentPeriodo.keys.elementAt(index);
                          double voto = currentPeriodo.values.elementAt(index).media;
                          int numVoti = currentPeriodo.values.elementAt(index).numeroVoti;
                          return InkWell(
                              child: _templateVoto(materia, voto, numVoti),
                              onTap: (){
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context){
                                      return cambiaObbiettivo(materia, obbiettivi.containsKey(materia) ? obbiettivi[materia] : 6);
                                    }
                                );
                              }
                          );
                        }
                    ) : FutureBuilder<List<PagellaStructure>>(
                      key: ValueKey<int>(selezionePeriodo),
                      future: _pagelle,
                      builder: (context, snapshot){
                        switch (snapshot.connectionState){
                          case ConnectionState.none:
                          case ConnectionState.active:
                          case ConnectionState.waiting:
                            return SobreroLoading(
                              loadingStringKey: "loadingAbsences",
                            );
                          case ConnectionState.done:
                            if (snapshot.hasError)
                              return SobreroError(
                                snapshotError: snapshot.error,
                              );

                            if (snapshot.data.length == 0)
                              return SobreroError(
                                snapshotError: "Previsioni non è disponibile fino a quando non è uscita la pagella del primo quadrimestre",
                              );

                            PagellaStructure pag1q = snapshot.data[0];
                            double mediaPrevista = 0;
                            List<Widget> previsioni = new List<Widget>();
                            widget.situazione2Q.forEach((key, value) {
                              try {
                                double voto1q = pag1q.materie[key.toUpperCase()].voto.toDouble();
                                double media1q = widget.situazione1Q[key].media;
                                double media2q = value.media;
                                double differenza = media1q - voto1q;
                                double mediaProbabile = media2q + differenza;
                                double parteDecMP = mediaProbabile % 1;
                                int pagellaProbabile = -1;
                                if (parteDecMP >= sogliaArrotondamento) pagellaProbabile = mediaProbabile.ceil();
                                else pagellaProbabile = mediaProbabile.floor();
                                if (pagellaProbabile > 10) pagellaProbabile = 10;
                                mediaPrevista += pagellaProbabile;
                                previsioni.add(_generaPrevisione(media2q, pagellaProbabile, voto1q, differenza, key));
                              } catch (e){
                                print("Errore in previsione!");
                                print(e.toString());
                              }
                            });
                            mediaPrevista /= widget.situazione2Q.length.toDouble();
                            previsioni.insert(0,
                              Column(
                                children: [
                                  Text(
                                    mediaPrevista.toStringAsFixed(2),
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Media totale prevista",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            );
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: ListView.builder(
                                  primary: false,
                                  shrinkWrap: true,
                                  itemCount: previsioni.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: previsioni[index],
                                    );
                                  }
                              ),
                            );
                        }
                        return null;
                      },
                    )
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
