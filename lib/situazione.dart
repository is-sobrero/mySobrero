import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class SituazioneView extends StatefulWidget {
  Map<String, double> situazione1Q, situazione2Q;
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


  Widget _templateVoto(String materia, double voto){
    List<Color> selezionato = sufficienza;
    if (voto < 7) selezionato = limite;
    if (voto < 6) selezionato = insufficienza;
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: 75,
                height: 75,
                child: SfRadialGauge(
                  axes: <RadialAxis>[RadialAxis(
                      showLabels: false,
                      startAngle: 270, endAngle: 270,
                      showTicks: false,
                      axisLineStyle: AxisLineStyle(thickness: 7),
                      pointers: <GaugePointer>[RangePointer(
                        value: voto * 10,
                        width: 7,
                        cornerStyle: CornerStyle.bothCurve,
                        gradient: SweepGradient(
                            colors: selezionato,
                            stops: <double>[0.25, 0.75]
                        ),
                      )]
                  )],
                ),
              ),
              Container(
                  width: 50,
                  child: AutoSizeText(
                    voto.toStringAsFixed(1),
                    minFontSize: 8,
                    maxLines: 1,
                    style: TextStyle(fontSize: 25, ),
                    textAlign: TextAlign.center,
                  )
              )
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(materia, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, double> currentPeriodo = selezionePeriodo == 0 ? widget.situazione1Q : widget.situazione2Q;
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
                                      double voto = currentPeriodo.values.elementAt(index);
                                      return _templateVoto(materia, voto);
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
