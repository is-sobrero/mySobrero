import 'package:flutter/material.dart';
import 'package:mySobrero/situazione.dart';
import 'reapi2.dart';
import 'package:expandable/expandable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';

class VotiView extends StatefulWidget {
  List<Voti> voti1q, voti2q;

  VotiView(List<Voti> voti1q, List<Voti> voti2q) {
    this.voti1q = voti1q;
    this.voti2q = voti2q;
  }

  @override
  _VotiView createState() => _VotiView(voti1q, voti2q);
}

class _VotiView extends State<VotiView> {
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

  @override
  Widget build(BuildContext context) {

    List<Color> gradientColors = [
      const Color(0xff23b6e6),
      const Color(0xff02d39a),
    ];

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
                            Text("Vai alla situazione", style: TextStyle(color: Theme.of(context).primaryColor),),
                            Icon(Icons.arrow_forward_ios, color: Theme.of(context).primaryColor,)
                          ],
                        ),
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SituazioneView()),
                          );
                        },
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      )
                    ],
                  ),
                  Center(
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
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: true,
                                    getDrawingHorizontalLine: (value) {
                                      return const FlLine(
                                        color: Color(0xff37434d),
                                        strokeWidth: 1,
                                      );
                                    },
                                    getDrawingVerticalLine: (value) {
                                      return const FlLine(
                                        color: Color(0xff37434d),
                                        strokeWidth: 1,
                                      );
                                    },
                                  ),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: votiT,
                                      isCurved: true,
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
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: generaVoti(currentVoti))
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
