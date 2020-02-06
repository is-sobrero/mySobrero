import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'reapi2.dart';
import 'fade_slide_transition.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class PagelleView extends StatefulWidget {
  List<Pagella> pagelle;

  PagelleView(List<Pagella> pagelle) {
    this.pagelle = pagelle;
  }

  @override
  _PagelleState createState() => _PagelleState(pagelle);
}

class _PagelleState extends State<PagelleView> with SingleTickerProviderStateMixin {
  List<Pagella> pagelle;
  Brightness currentBrightness;

  _PagelleState(List<Pagella> pagelle) {
    this.pagelle = pagelle;
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
    0: Text('1^ Quad', style: TextStyle(color: Colors.white)),
    1: Text('2^ Quad', style: TextStyle(color: Colors.white)),
  };

  int selezionaPagella = 0;

  Pagella selectedPagella;

  @override
  Widget build(BuildContext context) {
    if (selezionaPagella == pagelle.length) selectedPagella = null;
    else selectedPagella = pagelle[selezionaPagella];
    currentBrightness = Theme.of(context).brightness;
    return Scaffold(
      body: Stack(
          children: <Widget>[
            Hero(
              tag: "pagelle_background",
              child: Container(
                color: Color(0xff38ada9),
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
                        child: Text("Pagelle",
                            style: TextStyle(color: Colors.white)),
                      ),
                      backgroundColor: Color(0xff38ada9),
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
                                  "Pagelle",
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
                                            selezionaPagella = val;
                                          });
                                        },
                                        groupValue: selezionaPagella,
                                      ),
                                    ),
                                    selectedPagella != null ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // TODO inserire pagelle
                                        Text("Media totale: ${selectedPagella.media}", style: TextStyle(
                                            fontSize: 20, color: Colors.white),),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 10),
                                          child: Text("Esito: ${selectedPagella.esito != "" ?  selectedPagella.esito  : "Non specificato"}", style: TextStyle(
                                              fontSize: 20, color: Colors.white),),
                                        ),
                                        ListView.builder(
                                          primary: false,
                                          shrinkWrap: true,
                                          itemCount: selectedPagella.materie.length,
                                          itemBuilder: (context, index) {
                                            VotoPagella mat = selectedPagella.materie[index];
                                            return Padding(
                                              padding: const EdgeInsets.only(bottom: 15),
                                              child: Container(
                                                  decoration: new BoxDecoration(
                                                      color: Colors.white.withAlpha(20),
                                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                                      border: Border.all(
                                                          width: 1.0,
                                                          color: Colors.white)),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(15.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.stretch,
                                                      children: <Widget>[
                                                        Text(mat.materia,
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                FontWeight.bold,
                                                                color: Colors.white)),
                                                        Padding(
                                                          padding: const EdgeInsets.only(bottom: 7.0),
                                                          child: Text("Voto: ${mat.voto}",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors.white)),
                                                        ),
                                                        Text("Ore di assenza: ${mat.assenze}",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors.white)),

                                                      ],
                                                    ),
                                                  )),
                                            );
                                          },
                                        )
                                      ],
                                    ) : new Text("Pagella non disponibile per il periodo selezionato", style: TextStyle(
                                        fontSize: 20, color: Colors.black),),
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
    );
  }

  int filterIndex = 0;
}
