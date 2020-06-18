// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mySobrero/fade_slide_transition.dart';

class AppColorScheme {
  final Color primaryColor = Color(0xFF0360e7);
  final Color secondaryColor = Color(0xFF0360e7);
  final Color scaffoldColor = Colors.white;
  final Color darkScaffoldColor = Color(0xff121212);
  final Color darkCardColor = Color(0xff212121);
  final Color darkBottomNavColor = Color(0xff242424);
  final Color darkCanvasColor = Color(0xff242424);
  final Color sectionColor = Color(0xFFfafafa);
  final Color darkSectionColor = Color(0xFF212121);

  List<Color> appGradient = [
    const Color(0xFF0287d1),
    const Color(0xFF0335ff),
  ];
}

class MainViewSimpleContainer extends StatelessWidget {
  MainViewSimpleContainer({
    Key key,
    @required this.title,
    @required this.children,
  }) :  assert(title != null),
        assert(children != null),
        super(key: key);

  String title;
  List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                  ),
                ),
              ),
              ...children,
            ],
          ),
        )
      ),
    );
  }
}

class UIHelper {
  BuildContext context;

  UIHelper({
    @required this.context,
  }) : assert(context != null);

  bool get isWide => MediaQuery.of(context).size.width > 500;

  int get columnCount {
    int columnCount = MediaQuery.of(context).size.width > 550 ? 2 : 1;
    columnCount = MediaQuery.of(context).size.width > 900 ? 3 : columnCount;
    return columnCount;
  }

  Color textColorByBackground (Color color) =>
    color.computeLuminance() > 0.45 ? Colors.black : Colors.white;

}

class DetailView extends StatefulWidget {
  String title;
  String tag;
  Color backgroundColor;
  Widget child;
  bool animateOpening;
  int _animationDuration;

  DetailView({
    Key key,
    @required this.title,
    @required this.tag,
    @required this.child,
    @required this.backgroundColor,
    this.animateOpening = true,
  }) :  assert(title != null),
        assert(tag != null),
        assert(child != null),
        assert(backgroundColor != null),
        assert(animateOpening != null),
        _animationDuration = animateOpening ? 1500 : 0,
        super(key: key);

  @override
  _DetailViewState createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView>
    with SingleTickerProviderStateMixin {

  TextStyle _defaultTextStyle;
  final double _listAnimationIntervalStart = 0.65;
  final double _preferredAppBarHeight = 56.0;
  final double _preferredAppBarElevation = 4;
  AnimationController _fadeSlideAnimationController;
  ScrollController _scrollController;
  double _appBarElevation = 0.0;
  double _appBarTitleOpacity = 0.0;

  UIHelper _uiHelper;

  @override
  void initState(){
    super.initState();

    _fadeSlideAnimationController = AnimationController(
      duration: Duration(milliseconds: widget._animationDuration),
      vsync: this,
    )..forward();

    _scrollController = ScrollController()..addListener(() {
      double oldElevation = _appBarElevation;
      double oldOpacity = _appBarTitleOpacity;

      if (_scrollController.offset > _scrollController.initialScrollOffset)
        _appBarElevation = _preferredAppBarElevation;
      else
        _appBarElevation = 0;

      if (_scrollController.offset > _scrollController.initialScrollOffset + _preferredAppBarHeight / 2)
        _appBarTitleOpacity = 1;
      else
        _appBarTitleOpacity = 0;

      if (oldElevation != _appBarElevation || oldOpacity != _appBarTitleOpacity)
        setState(() {});
    });

    _uiHelper = UIHelper(context: context);
  }

  @override
  void dispose() {
    _fadeSlideAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _defaultTextStyle = Theme.of(context).textTheme.bodyText1.copyWith(
      color: _uiHelper.textColorByBackground(widget.backgroundColor),
    );
    return Hero(
      tag: widget.tag,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          brightness: Theme.of(context).brightness,
          title: AnimatedOpacity(
            opacity: _appBarTitleOpacity,
            duration: Duration(milliseconds: 250),
            child: Text(
              widget.title,
              style: TextStyle(
                color: _defaultTextStyle.color
              ),
            ),
          ),
          backgroundColor: widget.backgroundColor,
          elevation: _appBarElevation,
          leading: BackButton(
            color: _defaultTextStyle.color,
          ),
        ),
        body: Stack(
          children: [
            Container(color: widget.backgroundColor),
            SafeArea(
              bottom: false,
              // TODO: valutare il togliere la column
              // TODO: valutare il togliere la scrollconfiguration
              child: Column(
                children: [
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: ScrollBehavior(),
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 20,),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FadeSlideTransition(
                              controller: _fadeSlideAnimationController,
                              slideAnimationTween: Tween<Offset>(
                                begin: Offset(0.0, 0.5),
                                end: Offset(0.0, 0.0),
                              ),
                              begin: 0.0,
                              end: _listAnimationIntervalStart,
                              child: Text(
                                widget.title,
                                style: _defaultTextStyle.copyWith(
                                    fontSize: 32.0,
                                    fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            FadeSlideTransition(
                              controller: _fadeSlideAnimationController,
                              slideAnimationTween: Tween<Offset>(
                                begin: Offset(0.0, 0.05),
                                end: Offset(0.0, 0.0),
                              ),
                              begin: _listAnimationIntervalStart - 0.15,
                              child: widget.child,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SobreroTextField extends StatelessWidget {
  EdgeInsets margin;
  bool obscureText;
  Widget suffixIcon;
  String hintText;
  TextEditingController controller;

  SobreroTextField({
    Key key,
    this.margin = EdgeInsets.zero,
    this.obscureText = false,
    this.suffixIcon,
    this.controller,
    this.hintText,
  }) :  assert(margin != null),
        assert(obscureText != null),
        super(key: key);

  @override
  Widget build (BuildContext context){
    return Container(
      alignment: Alignment.centerLeft,
      margin: margin,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withAlpha(12),
            blurRadius: 10,
            spreadRadius: 10,
          ),
        ],
      ),
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
          isDense: false,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          suffixIcon: suffixIcon,
          hintText: hintText,
        ),
      ),
    );
  }
}