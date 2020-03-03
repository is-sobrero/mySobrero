import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mySobrero/situazione.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'reapi2.dart';
import 'package:expandable/expandable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:waterfall_flow/waterfall_flow.dart';


class VotiView extends StatefulWidget {
  List<Voti> voti1q, voti2q;

  VotiView(List<Voti> voti1q, List<Voti> voti2q) {
    this.voti1q = voti1q;
    this.voti2q = voti2q;
  }

  @override
  _VotiView createState() => _VotiView(voti1q, voti2q);
}

class _VotiView extends State<VotiView> with AutomaticKeepAliveClientMixin<VotiView>{
  @override
  bool get wantKeepAlive => true;

  List<Voti> voti, voti1q, voti2q;
  List<double> votiTotali;
  List<String> materie;

  Map<int, Widget> _children = const <int, Widget> {
    0: Text('1^ Quad.',),
    1: Text('2^ Quad.',),
  };
  int selezionePeriodo = 0;

  _VotiView(List<Voti> voti1q, List<Voti> voti2q) {
    this.voti1q = voti1q;
    this.voti2q = voti2q;
    this.voti = voti1q;

    materie = new List();
    materie.add("Tutte le materie");
    for (int i = 0; i < voti1q.length; i++) {
      String m = voti1q[i].materia;
      if (!materie.contains(m)) materie.add(m);
    }
  }
  
  Map<String, double> sommaVoti1Q = new Map<String, double>();
  Map<String, double> sommaVoti2Q = new Map<String, double>();
  Map<String, int> countVoti1Q = new Map<String, int>();
  Map<String, int> countVoti2Q = new Map<String, int>();

  Map<String, SituazioneElement> situazione1Q = new Map<String, SituazioneElement>();
  Map<String, SituazioneElement> situazione2Q = new Map<String, SituazioneElement>();

  Map<String, int> obbiettivi = Map<String, int>();
  bool ottenutoObbiettivi = false;

  Future<bool> ottieniObbiettivi() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = await prefs.getString('username') ?? "NO";
    final DocumentSnapshot dataRetrieve = await Firestore.instance.collection('utenti').document(username).get();
    if (dataRetrieve.data["obbiettivi"].toString() != "null") {
      print("HO GLI OBBIETTIVI");
      Map<String, dynamic> _tempObbiettivi = jsonDecode(dataRetrieve.data["obbiettivi"].toString());
      _tempObbiettivi.forEach((key, value){
        obbiettivi[key] = int.parse(value.toString());
      });
    }
  }

  Widget _generaTileVoto(Voti voto){
    LinearGradient sfondoVoto = LinearGradient(
      begin: FractionalOffset.topRight,
      end: FractionalOffset.bottomRight,
      colors: <Color>[Color(0xFF38f9d7), Color(0xFF43e97b)],
    );
    double votoParsed = double.parse(voto.voto.replaceAll(",", "."));
    Color coloreTesto = Colors.black;
    if (votoParsed >= 6 && votoParsed < 7) {
      sfondoVoto = LinearGradient(
        begin: FractionalOffset.topRight,
        end: FractionalOffset.bottomRight,
        colors: <Color>[Color(0xffFFD200), Color(0xffF7971E)],
      );
    }
    if (votoParsed < 6) {
      sfondoVoto = LinearGradient(
        begin: FractionalOffset.topRight,
        end: FractionalOffset.bottomRight,
        colors: <Color>[Color(0xffFF416C), Color(0xffFF4B2B)],
      );
      coloreTesto = Colors.white;
    }

    var commento = voto.commento;
    if (commento.length == 0) commento = "Nessun commento al voto";

    if (voto.peso == "0") {
      sfondoVoto = LinearGradient(
        begin: FractionalOffset.topRight,
        end: FractionalOffset.bottomRight,
        colors: <Color>[Color(0xff005C97), Color(0xff363795)],
      );
      coloreTesto = Colors.white;
    }

    return ExpandableNotifier(
      child: Column(
        children: [
          Expandable(
            collapsed: ExpandableButton(
              child: Container(
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(11)),
                    gradient: sfondoVoto,
                    boxShadow: <BoxShadow>[
                      BoxShadow(color: sfondoVoto.colors[1].withOpacity(0.4), offset: const Offset(1.1, 1.1), blurRadius: 10.0),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Text(voto.voto, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: coloreTesto)),
                        ),
                        Expanded(child: Text(voto.materia, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: coloreTesto)))
                      ],
                    ),
                  ),
                ),

            ),
            expanded: Column(children: [
              ExpandableButton(
                  child: Container(
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(11)),
                      gradient: sfondoVoto,
                      boxShadow: <BoxShadow>[
                        BoxShadow(color: sfondoVoto.colors[1].withOpacity(0.4), offset: const Offset(1.1, 1.1), blurRadius: 10.0),
                      ],
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: Text(voto.voto, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: coloreTesto)),
                                ),
                                Expanded(child: Text(voto.materia, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: coloreTesto)))
                              ],
                            ),
                            Text("Data voto: ${voto.data}", style: TextStyle(color: coloreTesto)),
                            Text("Tipologia: ${voto.tipologia}", style: TextStyle(color: coloreTesto)),
                            Text("Docente: ${voto.docente}", style: TextStyle(color: coloreTesto)),
                            Text("Peso: ${voto.peso}", style: TextStyle(color: coloreTesto)),
                            Text("Commento al voto: $commento", style: TextStyle(color: coloreTesto)),
                          ],
                        )),
                  ),

              ),
            ]),
          ),
        ],
      ),
    );
  }

  void initState(){
    super.initState();
    for (int i = 0; i < voti1q.length; i++) {
      double votoParsed = double.parse(voti1q[i].voto.replaceAll(",", "."));
      if (!sommaVoti1Q.containsKey(voti1q[i].materia)) {
        sommaVoti1Q[voti1q[i].materia] = 0;
        countVoti1Q[voti1q[i].materia] = 0;
      }
      sommaVoti1Q[voti1q[i].materia] += votoParsed * int.parse(voti1q[i].peso);
      countVoti1Q[voti1q[i].materia] += int.parse(voti1q[i].peso);
    }
    sommaVoti1Q.forEach((key, value){
      situazione1Q[key] =  SituazioneElement(countVoti1Q[key].toInt() ~/ 100, sommaVoti1Q[key] / countVoti1Q[key]);
    });
    for (int i = 0; i < voti2q.length; i++) {
      double votoParsed = double.parse(voti2q[i].voto.replaceAll(",", "."));
      if (!sommaVoti2Q.containsKey(voti2q[i].materia)) {
        sommaVoti2Q[voti2q[i].materia] = 0;
        countVoti2Q[voti2q[i].materia] = 0;
      }
      sommaVoti2Q[voti2q[i].materia] += votoParsed * int.parse(voti2q[i].peso);
      countVoti2Q[voti2q[i].materia] += int.parse(voti2q[i].peso);
    }
    sommaVoti2Q.forEach((key, value){
      situazione2Q[key] = SituazioneElement(countVoti2Q[key].toInt() ~/ 100, sommaVoti2Q[key] / countVoti2Q[key]);
    });
    ottieniObbiettivi().then((res){
      setState(() {
        ottenutoObbiettivi = true;
      });
    });
  }

  List<Widget> generaVoti(List<Voti> valutazioni) {
    double media = 0;
    double sommaPesi = 0;
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < valutazioni.length; i++) {
      LinearGradient sfondoVoto = LinearGradient(
        begin: FractionalOffset.topRight,
        end: FractionalOffset.bottomRight,
        colors: <Color>[Color(0xFF38f9d7), Color(0xFF43e97b)],
      );
      double votoParsed = double.parse(valutazioni[i].voto.replaceAll(",", "."));
      Color coloreTesto = Colors.black;
      if (votoParsed >= 6 && votoParsed < 7) {
        sfondoVoto = LinearGradient(
          begin: FractionalOffset.topRight,
          end: FractionalOffset.bottomRight,
          colors: <Color>[Color(0xffFFD200), Color(0xffF7971E)],
        );
      }
      if (votoParsed < 6) {
        sfondoVoto = LinearGradient(
          begin: FractionalOffset.topRight,
          end: FractionalOffset.bottomRight,
          colors: <Color>[Color(0xffFF416C), Color(0xffFF4B2B)],
        );
        coloreTesto = Colors.white;
      }

      final tipologia = valutazioni[i].tipologia;
      final peso = valutazioni[i].peso;
      sommaPesi += int.parse(peso);
      media += votoParsed * int.parse(peso);
      final docente = valutazioni[i].docente;
      final data = valutazioni[i].data;
      var commento = valutazioni[i].commento;
      if (commento.length == 0) commento = "Nessun commento al voto";

      if (peso == "0") {
        sfondoVoto = LinearGradient(
          begin: FractionalOffset.topRight,
          end: FractionalOffset.bottomRight,
          colors: <Color>[Color(0xff005C97), Color(0xff363795)],
        );
        coloreTesto = Colors.white;
      }

      list.add(ExpandableNotifier(
        child: Column(
          children: [
            Expandable(
              collapsed: ExpandableButton(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(11)),
                      gradient: sfondoVoto,
                      boxShadow: <BoxShadow>[
                        BoxShadow(color: sfondoVoto.colors[1].withOpacity(0.4), offset: const Offset(1.1, 1.1), blurRadius: 10.0),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Text(valutazioni[i].voto, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: coloreTesto)),
                          ),
                          Expanded(child: Text(valutazioni[i].materia, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: coloreTesto)))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              expanded: Column(children: [
                ExpandableButton(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(11)),
                        gradient: sfondoVoto,
                        boxShadow: <BoxShadow>[
                          BoxShadow(color: sfondoVoto.colors[1].withOpacity(0.4), offset: const Offset(1.1, 1.1), blurRadius: 10.0),
                        ],
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: Text(valutazioni[i].voto, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: coloreTesto)),
                                  ),
                                  Expanded(child: Text(valutazioni[i].materia, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: coloreTesto)))
                                ],
                              ),
                              Text("Data voto: $data", style: TextStyle(color: coloreTesto)),
                              Text("Tipologia: $tipologia", style: TextStyle(color: coloreTesto)),
                              Text("Docente: $docente", style: TextStyle(color: coloreTesto)),
                              Text("Peso: $peso", style: TextStyle(color: coloreTesto)),
                              Text("Commento al voto: $commento", style: TextStyle(color: coloreTesto)),
                            ],
                          )),
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ));
    }
    media /= sommaPesi;
    final finalMedia = media.toStringAsFixed(2);
    list.insert(
        0,
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Text(filterIndex > 0 ? "Media ponderata della materia: $finalMedia" : "Media ponderata attuale: $finalMedia"),
        ));
    return list;
  }

  int filterIndex = 0;
  int crossCount;

  @override
  Widget build(BuildContext context) {
    List<Color> gradientColors = [
      const Color(0xff23b6e6),
      const Color(0xff02d39a),
    ];
    bool isWide = MediaQuery.of(context).size.width > 500;
    int columnCount = MediaQuery.of(context).size.width > 550 ? 2 : 1;
    columnCount = MediaQuery.of(context).size.width > 800 ? 3 : columnCount;
    List<Voti> currentVoti;
    List<Voti> periodoSelezionato = selezionePeriodo == 0 ? voti1q : voti2q;
    if (filterIndex == 0) currentVoti = periodoSelezionato;
    else {
      String materia = materie[filterIndex];
      currentVoti = List();
      for (int i = 0; i < periodoSelezionato.length; i++) if (periodoSelezionato[i].materia == materia) currentVoti.add(periodoSelezionato[i]);
    }
    List<FlSpot> votiT = new List();
    int j = 0;
    for (int i = 0; i < currentVoti.length; i++) {
      double votoParsed = double.parse(currentVoti[i].voto.replaceAll(",", "."));
      votiT.add(FlSpot(200-(j++).toDouble(), votoParsed));
    }
    Color linkDis = ottenutoObbiettivi ? Theme.of(context).primaryColor : Theme.of(context).disabledColor;

    return SingleChildScrollView(
          child: SafeArea(
            top: false,
            child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            'Tutti i voti',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 24,
                            ),
                          ),
                          Spacer(),
                          FlatButton(
                            child: Row(
                              children: <Widget>[
                                Text(ottenutoObbiettivi ? "Vai alla situazione" : "Caricando gli obbiettivi", style: TextStyle(color: linkDis),),
                                ottenutoObbiettivi ? Icon(Icons.arrow_forward_ios, color: linkDis,) : Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: SpinKitDualRing(
                                    color: Theme.of(context).disabledColor,
                                    size: 20,
                                    lineWidth: 3,
                                  ),
                                ),
                              ],
                            ),
                            onPressed: ottenutoObbiettivi ? (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SituazioneView(
                                  situazione1Q: situazione1Q, situazione2Q: situazione2Q,
                                  obbiettivi: obbiettivi, onObbiettiviChange: (_nob){
                                    print("changeObbiettivi");
                                    setState(() {
                                      obbiettivi = _nob;
                                    });
                                  },
                                )),
                              );
                            } : null,
                            padding: EdgeInsets.zero,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: isWide ? 0 : 40.0),
                        child: Center(
                          child: Padding(
                            padding:
                            const EdgeInsets.only(bottom: 5, top: 3),
                            child: CupertinoSlidingSegmentedControl(
                              children: _children,
                              onValueChanged: (val) {
                                List<Voti> periodoSelezionato = val == 0 ? voti1q : voti2q;
                                materie = new List();
                                materie.add("Tutte le materie");
                                for (int i = 0; i < periodoSelezionato.length; i++) {
                                  String m = periodoSelezionato[i].materia;
                                  if (!materie.contains(m)) materie.add(m);
                                }
                                setState(() {
                                  filterIndex = 0;
                                  selezionePeriodo = val;
                                });
                              },
                              groupValue: selezionePeriodo,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  currentVoti.length > 0 ? Column(children: <Widget>[
                      Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                          child: Container(
                              decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  new BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    spreadRadius: 4,
                                    offset: new Offset(0.0, 0.0),
                                    blurRadius: 15.0,
                                  ),
                                ],
                              ),
                              child: Card(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            icon: Icon(Icons.unfold_more, color: Theme.of(context).primaryColor),
                                            isExpanded: true,
                                            hint: Text("Seleziona elemento", overflow: TextOverflow.ellipsis,),
                                            value: materie[filterIndex],
                                            onChanged: (String Value) {
                                              setState(() {
                                                filterIndex = materie.indexOf(Value);
                                              });
                                            },
                                            items: materie.map((String user) {
                                              return DropdownMenuItem<String>(
                                                value: user,
                                                child:
                                                Text(
                                                  user,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                                margin: EdgeInsets.zero,

                              )),
                        ),
                      ],
                    ),
                      Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            height: 150,
                            child: LineChart(
                              LineChartData(
                                  titlesData: FlTitlesData(show: false),
                                  borderData: FlBorderData(show: false),
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: true,
                                    getDrawingHorizontalLine: (value) {
                                      return  FlLine(
                                        color: Theme.of(context).textTheme.body1.color.withAlpha(100),
                                        strokeWidth: 1,
                                      );
                                    },
                                    getDrawingVerticalLine: (value) {
                                      return FlLine(
                                        color: Theme.of(context).textTheme.body1.color.withAlpha(100),
                                        strokeWidth: 1,
                                      );
                                    },
                                  ),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: votiT,
                                      curveSmoothness: 0.5,
                                      isCurved: false,
                                      colors: gradientColors,
                                      belowBarData: BarAreaData(
                                        show: true,
                                        colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    WaterfallFlow.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: currentVoti.length,
                      itemBuilder: (context, i){
                        return _generaTileVoto(currentVoti[i]);
                        },
                      gridDelegate: SliverWaterfallFlowDelegate(
                        crossAxisCount: columnCount,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                          lastChildLayoutTypeBuilder: (index) => index == currentVoti.length
                          ? LastChildLayoutType.foot
                              : LastChildLayoutType.none,
                          ),
                        ),

                  ]) : new Text("Nessun voto disponibile per il periodo selezionato")
                ],
              ),
            ),
        ],
      ),
          ),
    );
  }
}
