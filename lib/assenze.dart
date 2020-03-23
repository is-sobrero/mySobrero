import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:mySobrero/reapi3.dart';
import 'fade_slide_transition.dart';
import 'reapi2.dart';

class AssenzeView extends StatefulWidget {
  reAPI3 apiInstance;

  AssenzeView({Key key, @required this.apiInstance}) : super(key: key);
  @override
  _AssenzeState createState() => _AssenzeState();
}

class _AssenzeState extends State<AssenzeView> with SingleTickerProviderStateMixin {
  final double _listAnimationIntervalStart = 0.65;
  final double _preferredAppBarHeight = 56.0;

  AnimationController _fadeSlideAnimationController;
  ScrollController _scrollController;
  double _appBarElevation = 0.0;
  double _appBarTitleOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
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
    _assenze = widget.apiInstance.retrieveAssenze();
  }

  Brightness currentBrightness;

  @override
  void dispose() {
    _fadeSlideAnimationController.dispose();
    _scrollController.dispose();
    FlutterStatusbarcolor.setStatusBarWhiteForeground(currentBrightness == Brightness.dark);
    super.dispose();
  }

  Future<AssenzeStructure> _assenze;

  @override
  Widget build(BuildContext context) {
    currentBrightness = Theme.of(context).brightness;
    AppBar titolo = AppBar(
      title: AnimatedOpacity(
        opacity: _appBarTitleOpacity,
        duration: const Duration(milliseconds: 250),
        child: Text("Assenze", style: TextStyle(color: Colors.black)),
      ),
      backgroundColor: Color(0xffff9692),
      elevation: _appBarElevation,
      leading: BackButton(
        color: Colors.black,
      ),
    );

    return Hero(
        tag: "assenze_background",
        child: Scaffold(
          appBar: _fadeSlideAnimationController.isCompleted ? titolo : null,
          backgroundColor: Color(0xffff9692),
          body: SafeArea(
            bottom: !_fadeSlideAnimationController.isCompleted,
            child: Column(children: <Widget>[
              !_fadeSlideAnimationController.isCompleted ? FadeSlideTransition(
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
                      child: Text("Assenze", style: TextStyle(color: Colors.black)),
                    ),
                    backgroundColor: Color(0xffff9692),
                    elevation: 0,
                    leading: BackButton(
                      color: Colors.black,
                    ),
                  ),
                ),
              ) : new Container(),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollBehavior(),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB( 20, 10, 20, 20,),
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
                                "Assenze",
                                style: Theme.of(context).textTheme.title.copyWith(
                                    fontSize: 32.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        FadeSlideTransition(
                          controller: _fadeSlideAnimationController,
                          slideAnimationTween: Tween<Offset>(
                            begin: Offset(0.0, 0.001),
                            end: Offset(0.0, 0.0),
                          ),
                          begin: _listAnimationIntervalStart - 0.15,
                          child: FutureBuilder<AssenzeStructure>(
                            future: _assenze,
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
                                          color: Colors.black,
                                          size: 40,
                                          lineWidth: 5,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Text("Sto caricando le assenze...", style: TextStyle(color: Colors.black, fontSize: 16), textAlign: TextAlign.center,),
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
                                          Icon(Icons.warning, size: 40, color: Colors.black,),
                                          Text("${snapshot.error}", style: TextStyle(color: Colors.black, fontSize: 16), textAlign: TextAlign.center,),
                                        ],
                                      ),
                                    );
                                  }
                                  return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 15.0, top: 20),
                                          child: Text(
                                    "Non giustificate",
                                    style: TextStyle(
                                        fontSize: 24, color: Colors.black),
                                  ),
                                        ),
                                        Column(
                                          children: snapshot.data.nongiustificate.length > 0 ? generaAssenze(
                                              snapshot.data.nongiustificate,
                                              Colors.red, context) : <Widget>[Text("Nessuna assenza da giustificare, ottimo!", textAlign: TextAlign.center,)
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 15.0),
                                          child: Text(
                                            snapshot.data.giustificate.length > 25 ? "Ultime 25 giustificate" : "Giustificate",
                                            style: TextStyle(fontSize: 24, color: Colors.black),
                                          ),
                                        ),
                                        Column(
                                          children: generaAssenze(
                                              snapshot.data.giustificate.length > 25 ? snapshot.data.giustificate.sublist(0, 24) : snapshot.data.giustificate,
                                              Colors.black.withAlpha(100),
                                              context),
                                        ),
                                      ]
                                  );
                              }
                              return null;
                            }
                            ),
                          ),
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

  List<Widget> generaAssenze(List<AssenzaStructure> assenze, Color borderColor, BuildContext context) {
    List<Widget> list = new List<Widget>();
    for (int i = 0; i < assenze.length; i++) {
      final String tipologia = assenze[i].tipologia;
      final String orario = assenze[i].orario;
      final String data = assenze[i].data;
      final String motivazione = assenze[i].motivazione;
      final String calcolo = assenze[i].calcolo == "0" ? "No" : "Sì";
      final Color scaffoldColor = borderColor == Colors.black.withAlpha(100) ? Color(0xffff9692) : borderColor;
      final Color onScaffoldColor = scaffoldColor == borderColor ? Colors.white : Colors.black;
      list.add(Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Container(
            decoration: new BoxDecoration(
              color: borderColor == Colors.black.withAlpha(100) ? Color(0xffff9692) : borderColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              //border: Border.all(width: 1.0, color: borderColor),
                boxShadow: [
                  BoxShadow(
                      color: borderColor.withAlpha(20),
                      blurRadius: 10,
                      spreadRadius: 10
                  )
                ]
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                      tipologia == "Assenza"
                          ? "Assenza del $data"
                          : "$tipologia alle ore $orario del $data",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: onScaffoldColor)),
                  Text("Motivazione: $motivazione",
                      style: TextStyle(fontSize: 16, color: onScaffoldColor)),
                  Text("Concorre al calcolo: $calcolo",
                      style: TextStyle(fontSize: 16, color: onScaffoldColor))
                ],
              ),
            )),
      ));
    }
    return list;
  }
}
