import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SituazioneElement{
  int numeroVoti;
  double media;
  SituazioneElement(this.numeroVoti, this.media);
}

class SituazioneView extends StatefulWidget {
  Map<String, SituazioneElement> situazione1Q, situazione2Q;
  SituazioneView({Key key, @required this.situazione1Q, @required this.situazione2Q}) : super(key: key);

  @override
  _SituazioneView createState() => _SituazioneView();
}

class SituaMateria{
  String materia;
  double media;
  SituaMateria(String materia, double media){
    this.materia = materia;
    this.media = media;
  }
}

class _SituazioneView extends State<SituazioneView> with SingleTickerProviderStateMixin {
  final double _listAnimationIntervalStart = 0.65;
  final double _preferredAppBarHeight = 56.0;

  AnimationController _fadeSlideAnimationController;
  ScrollController _scrollController;
  double _appBarElevation = 0.0;
  double _appBarTitleOpacity = 0.0;

  _SituazioneView() {}

  Map<int, Widget> _children = const <int, Widget>{
    0: Text(
      '1^ Quad.',
    ),
    1: Text(
      '2^ Quad.',
    ),
  };

  int selezionePeriodo = 0;

  @override
  void initState() {
    super.initState();
    _fadeSlideAnimationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
    _scrollController = ScrollController()
      ..addListener(() {
        double oldElevation = _appBarElevation;
        double oldOpacity = _appBarTitleOpacity;
        _appBarElevation = _scrollController.offset > _scrollController.initialScrollOffset ? 4.0 : 0.0;
        _appBarTitleOpacity = _scrollController.offset > _scrollController.initialScrollOffset + _preferredAppBarHeight / 2 ? 1.0 : 0.0;
        if (oldElevation != _appBarElevation || oldOpacity != _appBarTitleOpacity) setState(() {});
      });
  }

  @override
  void dispose() {
    _fadeSlideAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  int selezioneCompiti = 0;

  final List<Color> sufficienza = <Color>[Color(0xff23b6e6), Color(0xff02d39a)];
  final List<Color> limite = <Color>[Color(0xffFFD200), Color(0xffF7971E)];
  final List<Color> insufficienza = <Color>[Color(0xffFF416C), Color(0xffFF4B2B)];


  Map <String, int> obbiettivi = {
    "Sistemi Elettronici Automatici" : 9
  };

  Widget _templateVoto(String materia, double voto, int numVoti){
    List<Color> selezionato = sufficienza;
    if (voto < 7) selezionato = limite;
    if (voto < 6) selezionato = insufficienza;

    bool esisteObbiettivo = obbiettivi.containsKey(materia);

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: <Widget>[
          new CircularPercentIndicator(
            radius: 75,
            lineWidth: 8,
            percent: 0.3,
            animation: true,
            animationDuration: 1200,
            circularStrokeCap: CircularStrokeCap.round,
            center: Container(
                width: 50,
                child: AutoSizeText(
                  voto.toStringAsFixed(1),
                  minFontSize: 8,
                  maxLines: 1,
                  style: TextStyle(fontSize: 25, ),
                  textAlign: TextAlign.center,
                )
            ),
            backgroundColor: Colors.black26,
            linearGradient: LinearGradient(
              colors: selezionato
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(materia, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  esisteObbiettivo ?
                    Text(ottieniVotiXMedia(voto, numVoti, obbiettivi[materia])) : Text("Tocca per impostare obbiettivo")
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  String ottieniVotiXMedia(double mediaAttuale, int countVoti, int obbiettivo){
    int volte = 0;
    double paramSoglia = 0.7;
    double finalVoto = -1;
    do {
      volte++;
      double sogliaMinima = obbiettivo - (1-paramSoglia);
      finalVoto = sogliaMinima * (countVoti + volte) - mediaAttuale * countVoti;
      finalVoto /= volte.toDouble();
    } while ((finalVoto < 1 || finalVoto > 10) && volte < 10);

    if (volte == 10){
      return "Impossibile raggiungere l'obbiettivo stabilito matematicamente";
    }

    String fineFrase = volte == 1 ? "a" : "e";
    if (mediaAttuale >= obbiettivo){
      return "Non prendere per $volte volt$fineFrase meno di ${finalVoto.toStringAsFixed(2)}";
    } else {
      return "Prendi per $volte volt$fineFrase almeno ${finalVoto.toStringAsFixed(2)}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, SituazioneElement> currentPeriodo = selezionePeriodo == 0 ? widget.situazione1Q : widget.situazione2Q;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(color: Theme.of(context).scaffoldBackgroundColor),
          SafeArea(
            child: Column(children: <Widget>[
              PreferredSize(
                preferredSize: Size.fromHeight(_preferredAppBarHeight),
                child: AppBar(
                  title: AnimatedOpacity(
                    opacity: _appBarTitleOpacity,
                    duration: const Duration(milliseconds: 250),
                    child: Text(
                      "Situazione attuale",
                      style: TextStyle(
                      color: Theme.of(context).textTheme.body1.color),
                    ),
                  ),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  elevation: _appBarElevation,
                  leading: BackButton(
                    color: Theme.of(context).textTheme.body1.color,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              "Situazione attuale",
                              style: Theme.of(context).textTheme.title.copyWith(fontSize: 32.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            "Arrotondamento impostato a 0.7",
                            style: Theme.of(context).textTheme.subtitle.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Column(
                              children: <Widget>[
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 5, top: 3),
                                    child: CupertinoSlidingSegmentedControl(
                                      children: _children,
                                      onValueChanged: (val) {
                                        setState(() {
                                          selezionePeriodo = val;
                                        });
                                      },
                                      groupValue: selezionePeriodo,
                                    ),
                                  ),
                                ),
                                ListView.builder(
                                    primary: false,
                                    shrinkWrap: true,
                                    itemCount: currentPeriodo.values.length,
                                    itemBuilder: (context, index){
                                      String materia = currentPeriodo.keys.elementAt(index);
                                      double voto = currentPeriodo.values.elementAt(index).media;
                                      int numVoti = currentPeriodo.values.elementAt(index).numeroVoti;
                                      return _templateVoto(materia, voto, numVoti);
                                    }
                                )
                              ],
                            ))
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
}
