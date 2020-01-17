import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'fade_slide_transition.dart';
import 'reapi2.dart';

class AssenzeView extends StatefulWidget {
  Assenze assenze;

  AssenzeView(Assenze assenze) {
    this.assenze = assenze;
  }
  @override
  _AssenzeState createState() => _AssenzeState(assenze);
}

class _AssenzeState extends State<AssenzeView>
    with SingleTickerProviderStateMixin {
  Assenze assenze;
  final double _listAnimationIntervalStart = 0.65;
  final double _preferredAppBarHeight = 56.0;

  AnimationController _fadeSlideAnimationController;
  ScrollController _scrollController;
  double _appBarElevation = 0.0;
  double _appBarTitleOpacity = 0.0;

  _AssenzeState(Assenze assenze) {
    this.assenze = assenze;
  }

  @override
  void initState() {
    super.initState();
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
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

  Brightness currentBrightness;

  @override
  void dispose() {
    _fadeSlideAnimationController.dispose();
    _scrollController.dispose();
    if (currentBrightness == Brightness.dark)
      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    currentBrightness = Theme.of(context).brightness;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Hero(
            tag: "assenze_background",
            child: Container(
              color: Color(0xffff9692),
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
                      child: Text("Assenze",
                          style: TextStyle(color: Colors.black)),
                    ),
                    backgroundColor: Color(0xffff9692),
                    elevation: _appBarElevation,
                    leading: BackButton(
                      color: Colors.black,
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
                                "Assenze",
                                style: Theme.of(context)
                                    .textTheme
                                    .title
                                    .copyWith(
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 15.0, top: 20),
                                child: Text(
                                  "Non giustificate",
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.black),
                                ),
                              ),
                              Column(
                                children: assenze.nongiustificate.length > 0
                                    ? generaAssenze(assenze.nongiustificate,
                                        Colors.red, context)
                                    : <Widget>[
                                        Text(
                                          "Nessuna assenza da giustificare, ottimo!",
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: Text(
                                  assenze.giustificate.length > 25
                                      ? "Ultime 25 giustificate"
                                      : "Giustificate",
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.black),
                                ),
                              ),
                              Column(
                                children: generaAssenze(
                                    assenze.giustificate.length > 25
                                        ? assenze.giustificate.sublist(0, 24)
                                        : assenze.giustificate,
                                    Colors.black.withAlpha(100),
                                    context),
                              ),
                            ],
                          ),
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

  List<Widget> generaAssenze(
      List<Assenza> assenze, Color borderColor, BuildContext context) {
    List<Widget> list = new List<Widget>();
    for (int i = 0; i < assenze.length; i++) {
      final String tipologia = assenze[i].tipologia;
      final String orario = assenze[i].orario;
      final String data = assenze[i].data;
      final String motivazione = assenze[i].motivazione;
      list.add(Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Container(
            decoration: new BoxDecoration(
              color: Colors.black.withAlpha(20),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(width: 1.0, color: borderColor),
              /*boxShadow: [BoxShadow(
                      color: borderColor.withAlpha(100),
                      spreadRadius: 1,
                      blurRadius: 10,
                    )]*/
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
                          color: Colors.black)),
                  Text("Motivazione: $motivazione",
                      style: TextStyle(fontSize: 16, color: Colors.black))
                ],
              ),
            )),
      ));
    }
    return list;
  }
}
