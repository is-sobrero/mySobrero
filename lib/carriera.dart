import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mySobrero/reapi3.dart';
import 'fade_slide_transition.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CarrieraView extends StatefulWidget {
  UnifiedLoginStructure unifiedLoginStructure;
  CarrieraView({Key key, @required this.unifiedLoginStructure}) : super(key: key);
  @override
  _CarrieraState createState() => _CarrieraState();
}

class _CarrieraState extends State<CarrieraView> with SingleTickerProviderStateMixin {

  final double _listAnimationIntervalStart = 0.65;
  final double _preferredAppBarHeight = 56.0;

  AnimationController _fadeSlideAnimationController;
  ScrollController _scrollController;
  double _appBarElevation = 0.0;
  double _appBarTitleOpacity = 0.0;

  int creditiPresiTotali = 0;
  int creditiNonPresiTotali = 0;

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

    for (int i = 0; i < widget.unifiedLoginStructure.user.curriculum.length; i++){
      final CurriculumStructure item = widget.unifiedLoginStructure.user.curriculum[i];
      final int anno = int.parse(item.classe);
      int credito = -1;
      if (item.credito.length > 0) credito = int.parse(item.credito.trim());
      int maxCredito = 12;
      if (anno == 4) maxCredito = 13;
      if (anno == 5) maxCredito = 15;
      if (credito > 0 && anno >= 3) {
        creditiNonPresiTotali += (maxCredito - credito);
        creditiPresiTotali += credito;
      }
    }
    print("Crediti presi: ${creditiPresiTotali}, Crediti non presi: ${creditiNonPresiTotali}");
  }

  @override
  void dispose() {
    _fadeSlideAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _generaAnno(CurriculumStructure anno){
    Color scaffoldColor;
    int shadowDepth = 20;
    if (anno.esito.contains("AMMESS")) scaffoldColor = Color(0xff45BF6D);
    else if (anno.credito.length == 0) {
      scaffoldColor  = Color(0xff0652DD);
      shadowDepth = 40;
    } else if (anno.esito.length == 0) scaffoldColor = Color(0xff45BF6D);
    else scaffoldColor  = Colors.red;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
          decoration: new BoxDecoration(
            //color: Theme.of(context).textTheme.body1.color.withAlpha(20),
              color: scaffoldColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              //border: Border.all(width: 0.0, color: Color(0xFFCCCCCC)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withAlpha(shadowDepth),
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: <Widget>[
                      Text("Classe ${anno.classe} ${anno.sezione.trim()}",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white
                        ),
                      ),
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withAlpha(50),
                              blurRadius: 10,
                              spreadRadius: 5
                            )
                          ]
                        ),
                        child: Chip(
                          label: Text(anno.credito.length == 0 ? "Anno in corso" : "${anno.credito} crediti", style: TextStyle(color: Colors.black),),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          backgroundColor: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                Text(anno.corso,
                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold,)),
                Text("Anno scolastico ${anno.anno}",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
                anno.esito.length > 0 ? Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(anno.esito,
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ) : Container(),
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: "carriera_background",
        child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: AnimatedOpacity(
              opacity: _appBarTitleOpacity,
              duration: const Duration(milliseconds: 250),
              child: Text("Carriera scolastica", style: TextStyle(color: Colors.white)),
            ),
            backgroundColor: Color(0xff45BF6D),
            elevation: _appBarElevation,
            leading: BackButton(color: Colors.white,),
          ),
          backgroundColor: Color(0xff45BF6D),
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
                                "Carriera scolastica",
                                style: Theme.of(context).textTheme.title.copyWith(
                                    fontSize: 32.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        ),
                        FadeSlideTransition(
                            controller: _fadeSlideAnimationController,
                            slideAnimationTween: Tween<Offset>(
                              begin: Offset(0.0, 0.05),
                              end: Offset(0.0, 0.0),
                            ),
                            begin: _listAnimationIntervalStart - 0.15,
                            child: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Stack(
                                      children: <Widget>[
                                        CircularPercentIndicator(
                                          radius: 175,
                                          lineWidth: 10,
                                          percent: (creditiNonPresiTotali + creditiPresiTotali) / 40,
                                          animation: true,
                                          animationDuration: 300,
                                          animateFromLastPercent: true,
                                          circularStrokeCap: CircularStrokeCap.round,
                                          center: Container(
                                              width: 130,
                                              child: AutoSizeText(
                                                "$creditiPresiTotali crediti presi\n$creditiNonPresiTotali crediti non presi\n${40-creditiPresiTotali} crediti ancora da prendere",
                                                minFontSize: 10,
                                                maxLines: 4,
                                                style: TextStyle(fontSize: 25, color: Colors.white),
                                                textAlign: TextAlign.center,
                                              )
                                          ),
                                          backgroundColor: Colors.transparent,
                                          linearGradient: LinearGradient(
                                              colors: <Color>[Color(0xfff9d423), Color(0xffff4e50)]
                                          ),
                                        ),
                                        CircularPercentIndicator(
                                          radius: 175,
                                          lineWidth: 10,
                                          percent: creditiPresiTotali / 40,
                                          animation: true,
                                          animationDuration: 300,
                                          animateFromLastPercent: true,
                                          circularStrokeCap: CircularStrokeCap.round,
                                          center: Container(
                                              width: 130,
                                              child: AutoSizeText(
                                                "$creditiPresiTotali crediti presi\n$creditiNonPresiTotali crediti non presi\n${40-creditiPresiTotali} crediti ancora da prendere",
                                                minFontSize: 10,
                                                maxLines: 4,
                                                style: TextStyle(fontSize: 25, color: Colors.white),
                                                textAlign: TextAlign.center,
                                              )
                                          ),
                                          backgroundColor: Colors.black26,
                                          linearGradient: LinearGradient(
                                              colors: <Color>[Color(0xff2af598), Color(0xff009efd)]
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: ListView.builder(
                                        addAutomaticKeepAlives: true,
                                        primary: false,
                                        shrinkWrap: true,
                                        itemCount: widget.unifiedLoginStructure.user.curriculum.length,
                                        itemBuilder: (context, index) => _generaAnno(widget.unifiedLoginStructure.user.curriculum[index]),
                                      ),
                                    )
                                  ],
                                )))
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
}
