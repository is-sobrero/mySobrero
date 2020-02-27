import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'fade_slide_transition.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'reapi2.dart';

class SituazioneView extends StatefulWidget {
  SituazioneView() {}

  @override
  _SituazioneView createState() => _SituazioneView();
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

  @override
  Widget build(BuildContext context) {
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
                  leading: BackButton(),
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
