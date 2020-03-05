import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'fade_slide_transition.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'reapi2.dart';

class CompitiView extends StatefulWidget {
  List<Compiti> compiti;
  List<Compiti> settimana;
  CompitiView(List<Compiti> compiti, List<Compiti> settimana) {
    this.compiti = compiti;
    this.settimana = settimana;
  }

  @override
  _CompitiState createState() => _CompitiState(this.compiti, this.settimana);
}

class _CompitiState extends State<CompitiView>
    with SingleTickerProviderStateMixin {
  List<Compiti> compiti;
  List<Compiti> settimana;
  final double _listAnimationIntervalStart = 0.65;
  final double _preferredAppBarHeight = 56.0;

  AnimationController _fadeSlideAnimationController;
  ScrollController _scrollController;
  double _appBarElevation = 0.0;
  double _appBarTitleOpacity = 0.0;

  Brightness currentBrightness;
  _CompitiState(List<Compiti> compiti, List<Compiti> settimana) {
    this.compiti = compiti;
    this.settimana = settimana;
  }

  Map<int, Widget> _children = const <int, Widget> {
    0: Text('Settimana', style: TextStyle(color: Colors.black)),
    1: Text('Tutti i compiti', style: TextStyle(color: Colors.black)),
  };

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
  }

  @override
  void dispose() {
    _fadeSlideAnimationController.dispose();
    _scrollController.dispose();
    FlutterStatusbarcolor.setStatusBarWhiteForeground(currentBrightness == Brightness.dark);
    super.dispose();
  }

  int selezioneCompiti = 0;

  @override
  Widget build(BuildContext context) {
    AppBar titolo = AppBar(
      title: AnimatedOpacity(
        opacity: _appBarTitleOpacity,
        duration: const Duration(milliseconds: 250),
        child: Text("Compiti", style: TextStyle(color: Colors.black)),
      ),
      backgroundColor: Color(0xFF43e97b),
      elevation: _appBarElevation,
      leading: BackButton(
        color: Colors.black,
      ),
    );
    currentBrightness = Theme.of(context).brightness;
    return Hero(
    tag: "compiti_background",
      child: Scaffold(
        appBar: _fadeSlideAnimationController.isCompleted ? titolo : null,
        backgroundColor: Color(0xFF43e97b),
        body: Stack(
          children: <Widget>[
            SafeArea(
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
                    child: titolo,
                  ),
                ) : new Container(),
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
                                  "Compiti",
                                  style:
                                      Theme.of(context).textTheme.title.copyWith(
                                            fontSize: 32.0,
                                            color: Colors.black,
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
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 15),
                                        child: CupertinoSlidingSegmentedControl(
                                          thumbColor: Colors.white,
                                          children: _children,
                                          onValueChanged: (val){
                                            setState((){
                                              selezioneCompiti = val;
                                            });
                                          },
                                          groupValue: selezioneCompiti,
                                        ),
                                      ),
                                      (selezioneCompiti == 0 ? settimana.length : compiti.length) > 0 ? ListView.builder(
                                        primary: false,
                                        shrinkWrap: true,
                                        itemCount: selezioneCompiti == 0 ? settimana.length : compiti.length,
                                        itemBuilder: (context2, index2) {
                                          List<Compiti> current = selezioneCompiti == 0 ? settimana : compiti;
                                          int i = selezioneCompiti == 0 ? index2 : current.length - index2 - 1;
                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 15),
                                            child: Container(
                                                decoration: new BoxDecoration(
                                                    color: Colors.black.withAlpha(20),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10)),
                                                    border: Border.all(
                                                        width: 1.0,
                                                        color: Colors.black)),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(15.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.stretch,
                                                    children: <Widget>[
                                                      Text(current[i].materia,
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              color: Colors.black)),
                                                      Padding(
                                                        padding: const EdgeInsets.only(bottom: 7.0),
                                                        child: Text("Data: " + current[i].data.split(" ")[0],
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors.black)),
                                                      ),
                                                      Text(current[i].compito,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors.black)),

                                                    ],
                                                  ),
                                                )),
                                          );
                                        },
                                      ) :
                                      Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.asset("assets/images/empty_state.png", width: 300,),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 15.0),
                                            child: Text("Nessun compito da visualizzare per il periodo selezionato", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                                          )
                                        ],
                                      ),
                                    ],
                                  )))
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
}
