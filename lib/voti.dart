import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'reapi.dart';
import 'package:expandable/expandable.dart';
import 'package:fl_chart/fl_chart.dart';

class VotiView extends StatefulWidget {
  List<Voti> voti;

  VotiView(List<Voti> voti){
    this.voti = voti;
  }
  @override
  _VotiView createState() => _VotiView(voti);
}

class _VotiView extends State<VotiView> {
  List<Voti> voti;
  List<double> votiTotali;
  _VotiView(List<Voti> voti){
    this.voti = voti;
    votiTotali = new List();
    for (int i = 0; i < voti.length; i++){
      double votoParsed = double.parse(voti[i].voto.replaceAll(",", "."));
      votiTotali.add(votoParsed);
    }
  }

  List<Widget> generaVoti(){
    double media = 0;
    List<Widget> list = new List<Widget>();
    for(var i = 0; i < voti.length; i++){
      LinearGradient sfondoVoto = LinearGradient(
        begin: FractionalOffset.topRight,
        end: FractionalOffset.bottomRight,
        colors: <Color>[Color(0xFF38f9d7), Color(0xFF43e97b)],
      );
      double votoParsed = double.parse(voti[i].voto.replaceAll(",", "."));
      media += votoParsed;
      if (votoParsed >= 6 && votoParsed < 7){
        sfondoVoto = LinearGradient(
          begin: FractionalOffset.topRight,
          end: FractionalOffset.bottomRight,
          colors: <Color>[Color(0xFFF9D423), Color(0xFFFF4E50)],
        );
      }
      final tipologia = voti[i].tipologia;
      final docente = voti[i].docente;
      final data = voti[i].data;
      var commento = voti[i].commento;
      if (commento.length == 0) commento = "Nessun commento al voto";

      list.add(ExpandableNotifier(  // <-- Provides ExpandableController to its children
        child: Column(
          children: [
            Expandable(
              collapsed: ExpandableButton(  // <-- Expands when tapped on the cover photo
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(11)),
                        gradient: sfondoVoto
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Text(voti[i].voto, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black)),
                          ),
                          Expanded(
                              child: Text(voti[i].materia, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black) ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              expanded: Column(
                  children: [
                    ExpandableButton(       // <-- Collapses when tapped on
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          decoration: new BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(11)),
                              gradient: sfondoVoto
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
                                      child: Text(voti[i].voto, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black)),
                                    ),
                                    Expanded(
                                        child: Text(voti[i].materia, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black) ))
                                  ],
                                ),
                                Text("Data voto: $data", style: TextStyle(color: Colors.black)),
                                Text("Tipologia: $tipologia", style: TextStyle(color: Colors.black)),
                                Text("Docente: $docente", style: TextStyle(color: Colors.black)),
                                Text("Commento al voto: $commento", style: TextStyle(color: Colors.black)),
                              ],
                            )
                          ),
                        ),
                      ),
                    ),
                  ]
              ),
            ),
          ],
        ),
      ));
    }
    media /= voti.length;
    list.insert(0, Padding(
      padding: const EdgeInsets.only(bottom : 15),
      child: Text("Media attuale: $media"),
    ));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    List<FlSpot> votiT = new List();
    for (int i = 0; i < voti.length; i++){
      double votoParsed = double.parse(voti[i].voto.replaceAll(",", "."));
      votiT.add(FlSpot(i.toDouble(), votoParsed));
    }
    List<Color> gradientColors = [
      const Color(0xff23b6e6),
      const Color(0xff02d39a),
    ];

    return SingleChildScrollView(
        child:Column(
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
                                lineBarsData:[
                                  LineChartBarData(
                                    spots: votiT,
                                    isCurved: true,
                                    colors: gradientColors,
                                    belowBarData: BarAreaData(
                                      show: true,
                                      colors:
                                      gradientColors.map((color) => color.withOpacity(0.3)).toList(),
                                    ),
                                )]
                            ),

                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: generaVoti()
                  )
                ],
              ),
            ),
          ],
        )
    );
  }
}