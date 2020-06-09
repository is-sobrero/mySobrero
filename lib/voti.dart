import 'dart:convert';
import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mySobrero/reapi3.dart';
import 'package:mySobrero/situazione.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expandable/expandable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:waterfall_flow/waterfall_flow.dart';


class VotiView extends StatefulWidget {
  List<VotoStructure> voti1q, voti2q;
  UnifiedLoginStructure unifiedLoginStructure;
  reAPI3 apiInstance;
  VotiView({Key key, @required this.unifiedLoginStructure, @required this.apiInstance}) {
    this.voti1q = unifiedLoginStructure.voti1Q;
    this.voti2q = unifiedLoginStructure.voti2Q;
  }

  @override
  _VotiView createState() => _VotiView();
}

class _VotiView extends State<VotiView> with AutomaticKeepAliveClientMixin<VotiView>{
  @override
  bool get wantKeepAlive => true;

  List<double> votiTotali;
  List<String> materie, materie2q;

  Map<int, Widget> _children = const <int, Widget> {
    0: Text('1^ Quad.',),
    1: Text('2^ Quad.',),
  };
  int selezionePeriodo = 0;

  _VotiView() {}
  
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

  Widget _generaTileVoto(VotoStructure voto){
    LinearGradient sfondoVoto = LinearGradient(
      begin: FractionalOffset.topRight,
      end: FractionalOffset.bottomRight,
      colors: <Color>[Color(0xFF38f9d7), Color(0xFF43e97b)],
    );
    Color coloreTesto = Colors.black;
    if (voto.votoValore >= 6 && voto.votoValore < 7) {
      sfondoVoto = LinearGradient(
        begin: FractionalOffset.topRight,
        end: FractionalOffset.bottomRight,
        colors: <Color>[Color(0xffFFD200), Color(0xffF7971E)],
      );
    }
    if (voto.votoValore < 6) {
      sfondoVoto = LinearGradient(
        begin: FractionalOffset.topRight,
        end: FractionalOffset.bottomRight,
        colors: <Color>[Color(0xffFF416C), Color(0xffFF4B2B)],
      );
      coloreTesto = Colors.white;
    }

    var commento = voto.commento;
    if (commento.length == 0) commento = "Nessun commento al voto";

    if (voto.pesoValore == 0) {
      sfondoVoto = LinearGradient(
        begin: FractionalOffset.topRight,
        end: FractionalOffset.bottomRight,
        colors: <Color>[Color(0xff005C97), Color(0xff363795)],
      );
      coloreTesto = Colors.white;
    }

    return ExpandableNotifier(
      child: Container (
        child: Expandable(
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
                          child: Text(voto.votoTXT, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: coloreTesto)),
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
                                  child: Text(voto.votoTXT, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: coloreTesto)),
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
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(color: sfondoVoto.colors[1].withOpacity(0.4), offset: const Offset(1.1, 1.1), blurRadius: 10.0),
          ],
        ),
      ),
    );
  }

  void initState(){
    super.initState();
    materie = new List();
    materie2q = new List();
    materie.add("Tutte le materie");
    materie2q.add("Tutte le materie");
    if (widget.voti2q.length > 0) selezionePeriodo = 1;
    for (int i = 0; i < widget.voti1q.length; i++) {
      String m = widget.voti1q[i].materia;
      if (!materie.contains(m)) materie.add(m);
    }
    for (int i = 0; i < widget.voti2q.length; i++) {
      String m = widget.voti2q[i].materia;
      if (!materie2q.contains(m)) materie2q.add(m);
    }
    for (int i = 0; i < widget.voti1q.length; i++) {
      if (!sommaVoti1Q.containsKey(widget.voti1q[i].materia)) {
        sommaVoti1Q[widget.voti1q[i].materia] = 0;
        countVoti1Q[widget.voti1q[i].materia] = 0;
      }
      if (widget.voti1q[i].votoValore > 0){
        sommaVoti1Q[widget.voti1q[i].materia] += widget.voti1q[i].votoValore * widget.voti1q[i].pesoValore;
        countVoti1Q[widget.voti1q[i].materia] += widget.voti1q[i].pesoValore;
      }
    }
    sommaVoti1Q.forEach((key, value){
      if (countVoti1Q[key] > 0){
        situazione1Q[key] =  SituazioneElement(countVoti1Q[key].toInt() ~/ 100, sommaVoti1Q[key] / countVoti1Q[key]);
      }
    });
    for (int i = 0; i < widget.voti2q.length; i++) {
      if (!sommaVoti2Q.containsKey(widget.voti2q[i].materia)) {
        sommaVoti2Q[widget.voti2q[i].materia] = 0;
        countVoti2Q[widget.voti2q[i].materia] = 0;
      }
      if (widget.voti2q[i].votoValore > 0){
        sommaVoti2Q[widget.voti2q[i].materia] += widget.voti2q[i].votoValore * widget.voti2q[i].pesoValore;
        countVoti2Q[widget.voti2q[i].materia] += widget.voti2q[i].pesoValore;
      }
    }
    sommaVoti2Q.forEach((key, value){
      if (countVoti2Q[key] > 0) {
        situazione2Q[key] = SituazioneElement(countVoti2Q[key].toInt() ~/ 100, sommaVoti2Q[key] / countVoti2Q[key]);
      }
    });
    ottieniObbiettivi().then((res){
      setState(() {
        ottenutoObbiettivi = true;
      });
    });
  }

  int filterIndex = 0;
  int crossCount;

  @override
  Widget build(BuildContext context) {
    List<Color> gradientColors = [
      const Color(0xFF0287d1),
      const Color(0xFF0335ff),
    ];
    List<Color> gradientColors2 = [
      const Color(0xFF0287d1),
      const Color(0xFF0287d1),
    ];
    bool isWide = MediaQuery.of(context).size.width > 500;
    int columnCount = MediaQuery.of(context).size.width > 550 ? 2 : 1;
    columnCount = MediaQuery.of(context).size.width > 900 ? 3 : columnCount;
    List<VotoStructure> currentVoti;
    List<VotoStructure> periodoSelezionato = selezionePeriodo == 0 ? widget.voti1q : widget.voti2q;
    if (filterIndex == 0) currentVoti = periodoSelezionato;
    else {
      String materia = selezionePeriodo == 0 ? materie[filterIndex] : materie2q[filterIndex];
      currentVoti = List();
      for (int i = 0; i < periodoSelezionato.length; i++) if (periodoSelezionato[i].materia == materia) currentVoti.add(periodoSelezionato[i]);
    }
    List<FlSpot> votiT = new List();
    int j = 0;
    for (int i = 0; i < currentVoti.length; i++) {
      if (currentVoti[i].pesoValore > 0)
        votiT.add(FlSpot(200-(j++).toDouble(), currentVoti[i].votoValore));
    }
    Color linkDis = ottenutoObbiettivi ? Theme.of(context).primaryColor : Theme.of(context).disabledColor;
    List<String> selectedFMaterie = selezionePeriodo == 0 ? materie : materie2q;
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
                                Text(ottenutoObbiettivi ? "Situazione" : "Caricando gli obbiettivi", style: TextStyle(color: linkDis),),
                                ottenutoObbiettivi ? Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Icon(Icons.flag, color: linkDis,),
                                ) : Padding(
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
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___)  => SituazioneView(
                                      situazione1Q: situazione1Q, situazione2Q: situazione2Q,
                                      apiInstance: widget.apiInstance,
                                      obbiettivi: obbiettivi, onObbiettiviChange: (_nob){
                                      print("changeObbiettivi");
                                      setState(() {
                                        obbiettivi = _nob;
                                      });
                                    },
                                    ),
                                    transitionDuration: Duration(milliseconds: 700),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      var begin = Offset(0.0, 1.0);
                                      var end = Offset.zero;
                                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOutExpo));
                                      var offsetAnimation = animation.drive(tween);
                                      return SharedAxisTransition(
                                        child: child,
                                        animation: animation,
                                        secondaryAnimation: secondaryAnimation,
                                        transitionType: SharedAxisTransitionType.vertical,
                                      );
                                    },

                                  )
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
                                List<VotoStructure> periodoSelezionato = val == 0 ? widget.voti1q : widget.voti2q;
                                /*materie = new List();
                                materie.add("Tutte le materie");
                                for (int i = 0; i < periodoSelezionato.length; i++) {
                                  String m = periodoSelezionato[i].materia;
                                  if (!materie.contains(m)) materie.add(m);
                                }*/
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
                                          child: Container(
                                            child: DropdownButton<String>(
                                              icon: Icon(Icons.unfold_more, color: Theme.of(context).primaryColor),
                                              isExpanded: false,
                                              hint: Text("Seleziona elemento", overflow: TextOverflow.ellipsis,),
                                              value: selectedFMaterie[filterIndex],
                                              onChanged: (String Value) {
                                                filterIndex = selectedFMaterie.indexOf(Value);
                                                setState(() {});
                                              },
                                              items: selectedFMaterie.map((String user) {
                                                return DropdownMenuItem<String>(
                                                  value: user,
                                                  child: Container(
                                                    child: Text(user, overflow: TextOverflow.ellipsis,),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
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
                                      colors: gradientColors2,
                                      belowBarData: BarAreaData(
                                        show: true,
                                        colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
                                        gradientFrom: Offset(0, 0),
                                        gradientTo: Offset(0, 1),
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
