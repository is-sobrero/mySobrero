import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mySobrero/reapi3.dart';
import 'fade_slide_transition.dart';

class PagelleView extends StatefulWidget {
  reAPI3 apiInstance;

  PagelleView({Key key, @required this.apiInstance}) : super(key: key);

  @override
  _PagelleState createState() => _PagelleState();
}

class _PagelleState extends State<PagelleView> with SingleTickerProviderStateMixin {

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
    _fadeSlideAnimationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
    _scrollController = ScrollController()..addListener(() {
      double oldElevation = _appBarElevation;
      double oldOpacity = _appBarTitleOpacity;
      _appBarElevation = _scrollController.offset > _scrollController.initialScrollOffset ? 4.0 : 0.0;
      _appBarTitleOpacity = _scrollController.offset > _scrollController.initialScrollOffset + _preferredAppBarHeight / 2 ? 1.0 : 0.0;
      if (oldElevation != _appBarElevation || oldOpacity != _appBarTitleOpacity) setState(() {});
    });
    _pagelle = widget.apiInstance.retrievePagelle();
  }

  @override
  void dispose() {
    _fadeSlideAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Map<int, Widget> _children = const <int, Widget>{
    0: Text('1^ Quad', style: TextStyle(color: Colors.white)),
    1: Text('2^ Quad', style: TextStyle(color: Colors.white)),
  };

  int selezionaPagella = 0;

  Future<List<PagellaStructure>> _pagelle;

  PagellaStructure selectedPagella;

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: "pagelle_background",
        child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: AnimatedOpacity(
              opacity: _appBarTitleOpacity,
              duration: const Duration(milliseconds: 250),
              child: Text("Pagelle", style: TextStyle(color: Colors.white)),
            ),
            backgroundColor: Color(0xff38ada9),
            elevation: _appBarElevation,
            brightness: Brightness.dark,
            leading: BackButton(
              color: Colors.white,
            ),
          ),
          backgroundColor: Color(0xff38ada9),
          body: SafeArea(
            bottom: false,
            child: Column(children: <Widget>[
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollBehavior(),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20,),
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
                                style: Theme.of(context).textTheme.title.copyWith(
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
                                  FutureBuilder<List<PagellaStructure>>(
                                    future: _pagelle,
                                    builder: (context, snapshot){
                                      switch (snapshot.connectionState){
                                        case ConnectionState.none:
                                        case ConnectionState.active:
                                        case ConnectionState.waiting:
                                          return Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Center(
                                              child: Column(
                                                children: <Widget>[
                                                  SpinKitDualRing(
                                                    color: Colors.white,
                                                    size: 40,
                                                    lineWidth: 5,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 8.0),
                                                    child: Text("Sto caricando le pagelle", style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center,),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        case ConnectionState.done:
                                          if (snapshot.hasError) {
                                            return Padding(
                                              padding: const EdgeInsets.fromLTRB(8.0, 15, 8, 15),
                                              child: Column(
                                                children: <Widget>[
                                                  Icon(Icons.warning, size: 40, color: Colors.white,),
                                                  Text("${snapshot.error}", style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center,),
                                                ],
                                              ),
                                            );
                                          }
                                          if (selezionaPagella == snapshot.data.length) selectedPagella = null;
                                          else selectedPagella = snapshot.data[selezionaPagella];

                                          return selectedPagella != null ? Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Media totale: ${selectedPagella.media.toStringAsFixed(2)}", style: TextStyle(
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
                                                  VotoFinaleStructure mat = selectedPagella.materie[index];
                                                  return Padding(
                                                    padding: const EdgeInsets.only(bottom: 15),
                                                    child: Container(
                                                        decoration: new BoxDecoration(
                                                          color: Color(0xff38ada9),
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Colors.black.withAlpha(20),
                                                                blurRadius: 10,
                                                                spreadRadius: 10
                                                            )
                                                          ],
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(15.0),
                                                          child:
                                                          Row(
                                                            children: <Widget>[
                                                              Padding(
                                                                padding: const EdgeInsets.only(right: 15),
                                                                child: Text(mat.voto.toString(), style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.white)),
                                                              ),
                                                              Expanded(child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: <Widget>[
                                                                  Text(mat.materia, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                                                  Text("Ore di assenza: ${mat.assenze}",
                                                                      style: TextStyle(
                                                                          fontSize: 16,
                                                                          color: Colors.white)),
                                                                ],
                                                              ))
                                                            ],
                                                          ),
                                                        )),
                                                  );
                                                },
                                              )
                                            ],
                                          ) : new Text("Pagella non disponibile per il periodo selezionato", style: TextStyle(
                                              fontSize: 20, color: Colors.white),);
                                      }
                                      return null;
                                    },
                                  )
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
        )
    );
  }

  int filterIndex = 0;
}
