// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPG 3.0 license that can be
// found in the LICENSE file.

import 'package:expandable/expandable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mySobrero/common/sobrero_icons.dart';
import 'package:mySobrero/situazione.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import 'package:animations/animations.dart';

import 'package:mySobrero/common/definitions.dart';
import 'package:mySobrero/common/pageswitcher.dart';
import 'package:mySobrero/common/ui.dart';
import 'package:mySobrero/reapi3.dart';
import 'package:mySobrero/cloud_connector/cloud.dart';

class VotesPage extends StatefulWidget {
  List<VotoStructure> voti1q, voti2q;
  UnifiedLoginStructure unifiedLoginStructure;
  reAPI3 apiInstance;
  VotesPage({Key key, @required this.unifiedLoginStructure, @required this.apiInstance}) {
    this.voti1q = unifiedLoginStructure.voti1Q;
    this.voti2q = unifiedLoginStructure.voti2Q;
  }

  @override
  _VotesPageState createState() => _VotesPageState();
}

class _VotesPageState extends State<VotesPage> with AutomaticKeepAliveClientMixin<VotesPage> {
  @override
  bool get wantKeepAlive => true;

  Map<String, SituazioneElement> situazione1Q, situazione2Q;
  List<String> materie1q, materie2q;
  Future<Map<String, int>> _goals;

  int periodFilter = 0, filterIndex = 0;

  Map<int, Widget> _filters = const <int, Widget> {
    0: Text('1^ Quad.',),
    1: Text('2^ Quad.',),
  };


  Map<String, SituazioneElement> generateSituazioneMap(List<VotoStructure> votes){
    Map<String, double> votesSum = new Map<String, double>();
    Map<String, double> votesCount = new Map<String, double>();
    Map<String, SituazioneElement> tempReturn = new Map<String, SituazioneElement>();
    votes.forEach((mark) {
      if (!votesSum.containsKey(mark.materia)){
        votesSum[mark.materia] = 0;
        votesCount[mark.materia] = 0;
      }
      if (mark.votoValore > 0){
        votesSum[mark.materia] += mark.votoValore * mark.pesoValore;
        votesCount[mark.materia] += mark.pesoValore;
      }
    });

    votesSum.forEach((key, value){
      if (votesCount[key] > 0){
        tempReturn[key] = SituazioneElement(votesCount[key].toInt() ~/ 100, votesSum[key] / votesCount[key]);
      }
    });
    return tempReturn;
  }

  List<String> generateSubjectsList (List<VotoStructure> marks) {
    List<String> tempReturn = new List<String>();
    tempReturn.add("Tutte le materie");
    marks.forEach((mark) {
      String m = mark.materia;
      if (!tempReturn.contains(m)) tempReturn.add(m);
    });
    return tempReturn;
  }

  void initState(){
    super.initState();
    materie1q = generateSubjectsList(widget.voti1q);
    materie2q = generateSubjectsList(widget.voti2q);

    situazione1Q = generateSituazioneMap(widget.voti1q);
    situazione2Q = generateSituazioneMap(widget.voti2q);

    _goals = getRemoteGoals(userID: widget.unifiedLoginStructure.user.matricola);

    if (widget.voti2q.length > 0) periodFilter = 1;
  }

  Widget buildVotesView(int period){
    return null;
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
          borderRadius: BorderRadius.all(Radius.circular(11)),
          gradient: sfondoVoto,
          boxShadow: <BoxShadow>[
            BoxShadow(color: sfondoVoto.colors[1].withOpacity(0.4), offset: const Offset(1.1, 1.1), blurRadius: 10.0),
          ],
        ),
      ),
    );
  }

  Widget _generatePeriodView(List<VotoStructure> marks, int columns, int key){
    if (marks.isEmpty)
      return Text("No voti");

    List<FlSpot> _marksSpots = new List();
    int xPos = 0;
    String _filterString = periodFilter == 0 ? materie1q[filterIndex] : materie2q[filterIndex];
    List<VotoStructure> _filteredList = new List<VotoStructure>();
    marks.forEach((mark) {
      if (mark.materia == _filterString || filterIndex == 0){
        if (mark.pesoValore > 0)
          _marksSpots.add(
              FlSpot(
                  200 - (xPos++).toDouble(),
                  mark.votoValore
              )
          );
        _filteredList.add(mark);
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      key: ValueKey<int>(key),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:[
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Container(
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
                            color: Theme.of(context).textTheme.bodyText1.color.withAlpha(100),
                            strokeWidth: 1,
                          );
                        },
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: Theme.of(context).textTheme.bodyText1.color.withAlpha(100),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: _marksSpots,
                          curveSmoothness: 0.5,
                          isCurved: false,
                          colors: [AppColorScheme().primaryColor, AppColorScheme().primaryColor],
                          belowBarData: BarAreaData(
                            show: true,
                            colors: AppColorScheme().appGradient.map((color) => color.withOpacity(0.3)).toList(),
                            gradientFrom: Offset(0, 0),
                            gradientTo: Offset(0, 1),
                          ),
                        )
                      ]),
                ),
              ),
            )
          ],
        ),
        WaterfallFlow.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: _filteredList.length,
          itemBuilder: (context, i) => _generaTileVoto(_filteredList[i]),
          gridDelegate: SliverWaterfallFlowDelegate(
            crossAxisCount: columns,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            lastChildLayoutTypeBuilder: (index) => index == widget.voti1q.length
                ? LastChildLayoutType.foot
                : LastChildLayoutType.none,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isWide = MediaQuery.of(context).size.width > 500;
    int columnCount = MediaQuery.of(context).size.width > 550 ? 2 : 1;
    columnCount = MediaQuery.of(context).size.width > 900 ? 3 : columnCount;
    List<String> currentSubjects = periodFilter == 0 ? materie1q : materie2q;
    return SingleChildScrollView(
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Row(
                    children: [
                      Text(
                        'Tutti i voti',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 24,
                        ),
                      ),
                      Spacer(),
                      FutureBuilder<Map<String, int>>(
                          future: _goals,
                          builder: (context, snapshot){
                            if (snapshot.hasData){
                              return FlatButton(
                                child: Row(
                                  children: <Widget>[
                                    Text("Situazione", style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Icon(LineIcons.flag, size: 20, color: Theme.of(context).primaryColor,),
                                    ),
                                  ],
                                ),
                                onPressed: () => Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (_, __, ___)  => SituazioneView(
                                        situazione1Q: situazione1Q, situazione2Q: situazione2Q,
                                        apiInstance: widget.apiInstance,
                                        obbiettivi: snapshot.data, onObbiettiviChange: (_nob){
                                          setState(() => _goals = getRemoteGoals(userID: widget.unifiedLoginStructure.user.matricola));
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
                                ),
                                padding: EdgeInsets.zero,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              );
                            } else if (snapshot.hasError){
                              return Row(
                                children: <Widget>[
                                  Text("Errore negli obbiettivi", style: TextStyle(color: Theme.of(context).errorColor),),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Icon(Icons.error, color: Theme.of(context).errorColor,),
                                  ),
                                ],
                              );
                            }
                            return Row(
                              children: <Widget>[
                                Text("Caricando gli obbiettivi", style: TextStyle(color: Theme.of(context).disabledColor),),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: SpinKitDualRing(
                                    color: Theme.of(context).disabledColor,
                                    size: 20,
                                    lineWidth: 3,
                                  ),
                                ),
                              ],
                            );
                          }
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: isWide ? 0 : 40.0),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5, top: 3),
                        // TODO: cambiare CupertinoSlidingSegmentedControl con un qualcosa di più decente
                        child: CupertinoSlidingSegmentedControl(
                          children: _filters,
                          onValueChanged: (val) {
                            filterIndex = 0;
                            setState(() => periodFilter = val);
                          },
                          groupValue: periodFilter,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 8, bottom: 20),
                child: Center(
                  child: Container(
                    decoration: new BoxDecoration(
                      //color: Theme.of(context).textTheme.body1.color.withAlpha(20),
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        //border: Border.all(width: 0.0, color: Color(0xFFCCCCCC)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12.withAlpha(12),
                              blurRadius: 10,
                              spreadRadius: 10
                          )
                        ]
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                      child: DropdownButtonHideUnderline(
                        child: Container(
                          child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton<String>(
                                icon: Icon(Icons.unfold_more, color: Theme.of(context).primaryColor),
                                isExpanded: true,
                                hint: Text("Seleziona elemento", overflow: TextOverflow.ellipsis,),
                                value: currentSubjects[filterIndex],
                                onChanged: (String value) {
                                  filterIndex = currentSubjects.indexOf(value);
                                  setState(() {});
                                },
                                items: materie1q.map((String user) {
                                  return DropdownMenuItem<String>(
                                    value: user,
                                    child: Text(user, overflow: TextOverflow.ellipsis,)
                                  );
                                }).toList(),
                              )
                          ),
                        ),
                      ),
                    ),
                    margin: EdgeInsets.zero,
                  ),
                ),
              ),
              PageTransitionSwitcher2(
                reverse: periodFilter == 0,
                layoutBuilder: (_entries) => Stack(
                  children: _entries
                      .map<Widget>((entry) => entry.transition)
                      .toList(),
                  alignment: Alignment.topLeft,
                ),
                duration: Duration(milliseconds: 700),
                transitionBuilder: (child, primary, secondary){
                  return SharedAxisTransition(
                    animation: primary,
                    secondaryAnimation: secondary,
                    transitionType: SharedAxisTransitionType.horizontal,
                    child: child,
                  );
                },
                child: _generatePeriodView(periodFilter == 0 ? widget.voti1q : widget.voti2q, columnCount, periodFilter)
              )
            ],
          ),
        )
      )
    );
  }
}