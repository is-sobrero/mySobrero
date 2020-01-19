import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'reapi2.dart';
import 'fade_slide_transition.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

import 'package:direct_select_flutter/direct_select_container.dart';
import 'package:direct_select_flutter/direct_select_item.dart';
import 'package:direct_select_flutter/direct_select_list.dart';

class ArgomentiView extends StatefulWidget {
  List<Argomenti> regclasse;
  List<Argomenti> argSettimana;

  ArgomentiView(List<Argomenti> regclasse) {
    this.regclasse = regclasse;
    bool okLista = false;
    this.argSettimana = List<Argomenti>();
    DateTime today = DateTime.now();
    var x = today.subtract(new Duration(days: today.weekday - 1));
    var formatter = new DateFormat('DD/MM/yyyy');
    String inizioSettimana = formatter.format(x);
    for (int i = 0; i < regclasse.length; i++) {
      if (regclasse[i].data.split(" ")[0] == inizioSettimana) okLista = true;
      if (okLista) this.argSettimana.add(regclasse[i]);
    }
  }

  @override
  _ArgomentiState createState() => _ArgomentiState(regclasse, argSettimana);
}

class _ArgomentiState extends State<ArgomentiView>
    with SingleTickerProviderStateMixin {
  List<Argomenti> regclasse;
  List<Argomenti> argSettimana;
  Brightness currentBrightness;

  _ArgomentiState(List<Argomenti> regclasse, List<Argomenti> argSettimana) {
    this.regclasse = regclasse;
    this.argSettimana = argSettimana;
  }

  final double _listAnimationIntervalStart = 0.65;
  final double _preferredAppBarHeight = 56.0;

  AnimationController _fadeSlideAnimationController;
  ScrollController _scrollController;
  double _appBarElevation = 0.0;
  double _appBarTitleOpacity = 0.0;

  List<String> materie;

  @override
  void initState() {
    super.initState();
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    _fadeSlideAnimationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _appBarElevation =
              _scrollController.offset > _scrollController.initialScrollOffset
                  ? 4.0
                  : 0.0;
          _appBarTitleOpacity = _scrollController.offset >
                  _scrollController.initialScrollOffset +
                      _preferredAppBarHeight / 2
              ? 1.0
              : 0.0;
        });
      });

    materie = new List();
    materie.add("Tutte le materie");
    for (int i = 0; i < regclasse.length; i++) {
      String m = regclasse[i].materia;
      if (!materie.contains(m)) materie.add(m);
    }
    regclasse = regclasse.reversed.toList();
  }

  @override
  void dispose() {
    _fadeSlideAnimationController.dispose();
    _scrollController.dispose();
    if (currentBrightness == Brightness.light)
      FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    super.dispose();
  }

  Map<int, Widget> _children = const <int, Widget>{
    0: Text('Settimana', style: TextStyle(color: Colors.white)),
    1: Text('Tutti gli argomenti', style: TextStyle(color: Colors.white)),
  };

  int selezioneArgomenti = 0;



  @override
  Widget build(BuildContext context) {
    String dataTemporanea = "";
    currentBrightness = Theme.of(context).brightness;
    List<Argomenti> currentSet =
        selezioneArgomenti == 0 ? argSettimana : regclasse;
    return Scaffold(
      body: DirectSelectContainer(
        child: Stack(
          children: <Widget>[
            Hero(
              tag: "argomenti_background",
              child: Container(
                color: Color(0xFF5352ed),
              ),
            ),
            SafeArea(
              child: Column(children: <Widget>[
                FadeSlideTransition(
                  controller: _fadeSlideAnimationController,
                  slideAnimationTween: Tween<Offset>(
                    begin: Offset(0.0, 0.5),
                    end: Offset(0.0, 0.0),
                  ),
                  begin: 0.0,
                  end: _listAnimationIntervalStart,
                  child: PreferredSize(
                    preferredSize: Size.fromHeight(_preferredAppBarHeight),
                    child: AppBar(
                      title: AnimatedOpacity(
                        opacity: _appBarTitleOpacity,
                        duration: const Duration(milliseconds: 250),
                        child: Text("Argomenti",
                            style: TextStyle(color: Colors.white)),
                      ),
                      backgroundColor: Color(0xFF5352ed),
                      elevation: _appBarElevation,
                      brightness: Brightness.dark,
                      leading: BackButton(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollBehavior(),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        10,
                        20,
                        20,
                      ),
                      child: Column(
                        children: <Widget>[
                          FadeSlideTransition(
                            controller: _fadeSlideAnimationController,
                            slideAnimationTween: Tween<Offset>(
                              begin: Offset(0.0, 0.5),
                              end: Offset(0.0, 0.0),
                            ),
                            begin: 0.0,
                            end: _listAnimationIntervalStart,
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Argomenti",
                                  style: Theme.of(context)
                                      .textTheme
                                      .title
                                      .copyWith(
                                          fontSize: 32.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          FadeSlideTransition(
                            controller: _fadeSlideAnimationController,
                            slideAnimationTween: Tween<Offset>(
                              begin: Offset(0.0, 0.005),
                              end: Offset(0.0, 0.0),
                            ),
                            begin: _listAnimationIntervalStart - 0.15,
                            child: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 15),
                                      child: CupertinoSlidingSegmentedControl(
                                        backgroundColor: Colors.black.withAlpha(50),
                                        thumbColor: Colors.black54,
                                        children: _children,
                                        onValueChanged: (val) {
                                          setState(() {
                                            selezioneArgomenti = val;
                                          });
                                        },
                                        groupValue: selezioneArgomenti,
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 15),
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
                                                color: Colors.black54,
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
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 12))),
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
                                    ListView.builder(
                                      addAutomaticKeepAlives: true,
                                      primary: false,
                                      shrinkWrap: true,
                                      itemCount: currentSet.length,
                                      itemBuilder: (context, index) {
                                        var mesi = [
                                          "Gennaio",
                                          "Febbraio",
                                          "Marzo",
                                          "Aprile",
                                          "Maggio",
                                          "Giugno",
                                          "Luglio",
                                          "Agosto",
                                          "Settembre",
                                          "Ottobre",
                                          "Novembre",
                                          "Dicembre"
                                        ];
                                        var tempString = currentSet[index]
                                            .data
                                            .split(" ")[0]
                                            .split("/");
                                        String formattedDate = tempString[0] +
                                            " " +
                                            mesi[int.parse(tempString[1]) - 1];
                                        bool mostraGiornata = true;

                                        final bool mostra = filterIndex == 0 ? true : currentSet[index].materia == materie[filterIndex];
                                        if (dataTemporanea != currentSet[index].data){
                                          dataTemporanea = currentSet[index].data;
                                          if (filterIndex != 0){
                                            mostraGiornata = false;
                                            print("filtro giornate");
                                            for (int i = 0; i < currentSet.length; i++){
                                              if (currentSet[i].materia == materie[filterIndex] && currentSet[i].data == dataTemporanea){
                                                mostraGiornata = true;
                                                break;
                                              }
                                            }
                                          }
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              mostraGiornata ? Padding(
                                                padding: const EdgeInsets.only(bottom: 15),
                                                child: Text(
                                                  formattedDate,
                                                  style: TextStyle(
                                                      fontSize: 24,
                                                      color: Colors.white),
                                                ),
                                              ) : Container(),
                                              mostra ? Padding(
                                                padding:
                                                const EdgeInsets.only(bottom: 15),
                                                child: Container(
                                                    decoration: new BoxDecoration(
                                                        color: Colors.white.withAlpha(20),
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(10)),
                                                        border: Border.all(
                                                            width: 1.0,
                                                            color: Colors.white)),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(15.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.stretch,
                                                        children: <Widget>[
                                                          Text(currentSet[index].materia,
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                  FontWeight.bold,
                                                                  color: Colors.white)),
                                                          Text(currentSet[index].descrizione.trim(),
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors.white)),

                                                        ],
                                                      ),
                                                    )),
                                              ) : Container()
                                            ],
                                          );
                                        }
                                        dataTemporanea = currentSet[index].data;
                                        return mostra ? Padding(
                                          padding:
                                          const EdgeInsets.only(bottom: 15),
                                          child: Container(
                                              decoration: new BoxDecoration(
                                                  color: Colors.white.withAlpha(20),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(10)),
                                                  border: Border.all(
                                                      width: 1.0,
                                                      color: Colors.white)),
                                              child: Padding(
                                                padding: const EdgeInsets.all(15.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                                  children: <Widget>[
                                                    Text(currentSet[index].materia,
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            color: Colors.white)),
                                                    Text(currentSet[index].descrizione.trim(),
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.white)),

                                                  ],
                                                ),
                                              )),
                                        ) : Container();
                                      },
                                    ),
                                  ],
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
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
}
