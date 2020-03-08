import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'fade_slide_transition.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'reapi2.dart';

class CarrieraView extends StatefulWidget {
  List<Curriculum> curriculum;
  CarrieraView({Key key, @required this.curriculum}) : super(key: key);

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

  Brightness currentBrightness;

  @override
  void initState() {
    super.initState();
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
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
    Map<int, int> creditiValidi;
    for (int i = 0; i < widget.curriculum.length; i++){
      final Curriculum item = widget.curriculum[i];
      final int anno = int.parse(item.anno.trim());
      final int credito = int.parse(item.credito.trim());
      if (int.parse(item.anno.trim()) >= 3){
        if (creditiValidi.containsKey(anno)) creditiValidi[anno] += credito;
        else creditiValidi[anno] = credito;
      }
    }
    print(creditiValidi);
  }

  @override
  void dispose() {
    _fadeSlideAnimationController.dispose();
    _scrollController.dispose();
    FlutterStatusbarcolor.setStatusBarWhiteForeground(currentBrightness == Brightness.dark);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    currentBrightness = Theme.of(context).brightness;
    AppBar titolo = AppBar(
      title: AnimatedOpacity(
        opacity: _appBarTitleOpacity,
        duration: const Duration(milliseconds: 250),
        child: Text("Carriera scolastica", style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: Color(0xff45BF6D),
      elevation: _appBarElevation,
      leading: BackButton(color: Colors.white,),
    );
    return Hero(
        tag: "carriera_background",
        child: Scaffold(
          appBar: _fadeSlideAnimationController.isCompleted ? titolo : null,
          backgroundColor: Color(0xff45BF6D),
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
                  child: titolo,
                ),
              ) : Container(),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[

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
