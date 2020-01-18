import 'package:flutter/material.dart';
import 'reapi2.dart';
import 'package:expandable/expandable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:direct_select_flutter/direct_select_container.dart';
import 'package:direct_select_flutter/direct_select_item.dart';
import 'package:direct_select_flutter/direct_select_list.dart';


class VotiView extends StatefulWidget {
  List<Voti> voti;

  VotiView(List<Voti> voti) {
    this.voti = voti;
  }
  @override
  _VotiView createState() => _VotiView(voti);
}

class _VotiView extends State<VotiView> {
  List<Voti> voti;
  List<double> votiTotali;
  List<String> materie;

  _VotiView(List<Voti> voti) {
    this.voti = voti;
    votiTotali = new List();
    for (int i = 0; i < voti.length; i++) {
      double votoParsed = double.parse(voti[i].voto.replaceAll(",", "."));
      votiTotali.add(votoParsed);
    }
    materie = new List();
    materie.add("Tutte le materie");
    for (int i = 0; i < voti.length; i++) {
      String m = voti[i].materia;
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
      double votoParsed =
          double.parse(valutazioni[i].voto.replaceAll(",", "."));
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
        // <-- Provides ExpandableController to its children
        child: Column(
          children: [
            Expandable(
              collapsed: ExpandableButton(
                // <-- Expands when tapped on the cover photo
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(11)),
                      gradient: sfondoVoto,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: sfondoVoto.colors[1].withOpacity(0.4),
                            offset: const Offset(1.1, 1.1),
                            blurRadius: 10.0),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Text(valutazioni[i].voto,
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: coloreTesto)),
                          ),
                          Expanded(
                              child: Text(valutazioni[i].materia,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: coloreTesto)))
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
                          BoxShadow(
                              color: sfondoVoto.colors[1].withOpacity(0.4),
                              offset: const Offset(1.1, 1.1),
                              blurRadius: 10.0),
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
                                    child: Text(valutazioni[i].voto,
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            color: coloreTesto)),
                                  ),
                                  Expanded(
                                      child: Text(valutazioni[i].materia,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: coloreTesto)))
                                ],
                              ),
                              Text("Data voto: $data",
                                  style: TextStyle(color: coloreTesto)),
                              Text("Tipologia: $tipologia",
                                  style: TextStyle(color: coloreTesto)),
                              Text("Docente: $docente",
                                  style: TextStyle(color: coloreTesto)),
                              Text("Peso: $peso",
                                  style: TextStyle(color: coloreTesto)),
                              Text("Commento al voto: $commento",
                                  style: TextStyle(color: coloreTesto)),
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

  DirectSelectItem<String> getDropDownMenuItem(String value) {
    return DirectSelectItem<String>(
        itemHeight: 56,
        value: value,
        itemBuilder: (context, value) {
          return Text(value);
        });
  }

  int filterIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<FlSpot> votiT = new List();
    for (int i = 0; i < voti.length; i++) {
      double votoParsed = double.parse(voti[i].voto.replaceAll(",", "."));
      votiT.add(FlSpot(voti.length - i.toDouble(), votoParsed));
    }
    List<Color> gradientColors = [
      const Color(0xff23b6e6),
      const Color(0xff02d39a),
    ];

    List<Voti> currentVoti;
    print(filterIndex);
    if (filterIndex == 0)
      currentVoti = voti;
    else {
      String materia = materie[filterIndex];
      currentVoti = List();
      for (int i = 0; i < voti.length; i++)
        if (voti[i].materia == materia) currentVoti.add(voti[i]);
    }

    return DirectSelectContainer(
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Tutti i voti',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                  ),
                ),
                voti.length > 0 ? Column(
                  children: <Widget>[
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
                                            child: DirectSelectList<String>(
                                                values: materie,
                                                defaultItemIndex: filterIndex,
                                                itemBuilder: (String value) =>
                                                    getDropDownMenuItem(value),
                                                focusedItemDecoration:
                                                BoxDecoration(
                                                  border: BorderDirectional(
                                                    bottom: BorderSide(
                                                        width: 1,
                                                        color: Colors.black12),
                                                    top: BorderSide(
                                                        width: 1,
                                                        color: Colors.black12),
                                                  ),
                                                ),
                                                onItemSelectedListener:
                                                    (string, index, context) {
                                                  setState(() {
                                                    filterIndex = index;
                                                  });
                                                }),
                                            padding: EdgeInsets.only(left: 12))),
                                    Padding(
                                      padding: EdgeInsets.only(right: 8),
                                      child: Icon(
                                        Icons.unfold_more,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    )
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
                                        colors: gradientColors
                                            .map((color) => color.withOpacity(0.3))
                                            .toList(),
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: generaVoti(currentVoti))
                  ]
                ) : new Text("Nessun voto disponibile per il periodo selezionato")
              ],
            ),
          ),
        ],
      )),
    );
  }
}
