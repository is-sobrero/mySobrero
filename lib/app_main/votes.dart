import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:mySobrero/common/definitions.dart';
import 'package:mySobrero/common/pageswitcher.dart';
import 'package:animations/animations.dart';
import 'package:mySobrero/reapi3.dart';
import 'package:mySobrero/cloud_connector/cloud.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

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

    _goals = getRemoteGoals(userID: "3845");
  }

  Widget selectedScreen = Text("primo");

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

  Widget _generate1QView(int columns){
    return Container(
      alignment: Alignment.topCenter,
      key: ValueKey<int>(770),
      child: WaterfallFlow.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: widget.voti1q.length,
        itemBuilder: (context, i){
          return _generaTileVoto(widget.voti1q[i]);
        },
        gridDelegate: SliverWaterfallFlowDelegate(
          crossAxisCount: columns,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          lastChildLayoutTypeBuilder: (index) => index == widget.voti1q.length
              ? LastChildLayoutType.foot
              : LastChildLayoutType.none,
        ),
      ),
    );
  }

  Widget _generate2QView(int columns){
    return Container(
      alignment: Alignment.topCenter,
      key: ValueKey<int>(772),
      child: WaterfallFlow.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: widget.voti2q.length,
        itemBuilder: (context, i){
          return _generaTileVoto(widget.voti2q[i]);
        },
        gridDelegate: SliverWaterfallFlowDelegate(
          crossAxisCount: columns,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          lastChildLayoutTypeBuilder: (index) => index == widget.voti2q.length
              ? LastChildLayoutType.foot
              : LastChildLayoutType.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isWide = MediaQuery.of(context).size.width > 500;
    int columnCount = MediaQuery.of(context).size.width > 550 ? 2 : 1;
    columnCount = MediaQuery.of(context).size.width > 900 ? 3 : columnCount;
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
                              return Text("ok obbiettivi");
                            } else if (snapshot.hasError){
                              return Text("errore");
                            }
                            return Text("caricando");
                          }
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
                          children: _filters,
                          onValueChanged: (val) {
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
                padding: EdgeInsets.only(top: 8),
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
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: DropdownButtonHideUnderline(
                          child: Container(
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton<String>(
                                icon: Icon(Icons.unfold_more, color: Theme.of(context).primaryColor),
                                isExpanded: false,
                                hint: Text("Seleziona elemento", overflow: TextOverflow.ellipsis,),
                                value: materie1q[filterIndex],
                                onChanged: (String Value) {
                                  //filterIndex = selectedFMaterie.indexOf(Value);
                                  setState(() {});
                                },
                                items: materie1q.map((String user) {
                                  return DropdownMenuItem<String>(
                                    value: user,
                                    child: Container(
                                      child: Text(user, overflow: TextOverflow.ellipsis,),
                                    ),
                                  );
                                }).toList(),
                              )
                            ),
                          ),
                        ),
                      ),
                      margin: EdgeInsets.zero,
                    )),
              ),
              PageTransitionSwitcher2(
                reverse: periodFilter == 0,
                alignment: Alignment.topLeft,
                transitionBuilder: (child, primary, secondary){
                  return SharedAxisTransition(
                    animation: primary,
                    secondaryAnimation: secondary,
                    transitionType: SharedAxisTransitionType.horizontal,
                    child: child,
                  );
                },
                child: periodFilter == 0 ? _generate1QView(columnCount) : _generate2QView(columnCount)
              )
            ],
          ),
        )
      )
    );
  }
}