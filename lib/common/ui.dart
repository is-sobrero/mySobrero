// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mySobrero/common/definitions.dart';
import 'package:mySobrero/fade_slide_transition.dart';

class AppColorScheme {
  static Color primaryColor = Color(0xFF0360e7);
  static Color secondaryColor = Color(0xFF0360e7);
  static Color scaffoldColor = Colors.white;
  static Color darkScaffoldColor = Color(0xff121212);
  static Color darkCardColor = Color(0xff212121);
  static Color darkBottomNavColor = Color(0xff242424);
  static Color darkCanvasColor = Color(0xff242424);
  static Color sectionColor = Color(0xFFfafafa);
  static Color darkSectionColor = Color(0xFF212121);

  static List<Color> appGradient = [
    const Color(0xFF0287d1),
    const Color(0xFF0335ff),
  ];

  static List<Color> greenGradient = [
    Color(0xFF38f9d7),
    Color(0xFF43e97b)
  ];

  static List<Color> yellowGradient = [
    Color(0xffFFD200),
    Color(0xffF7971E)
  ];

  static List<Color> redGradient = [
    Color(0xffFF416C),
    Color(0xffFF4B2B),
  ];

  static List<Color> blueGradient = [
    Color(0xff005C97),
    Color(0xff363795),
  ];
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
  int animationDuration;
  bool overridePadding;

  DetailView({
    Key key,
    @required this.title,
    @required this.tag,
    @required this.child,
    @required this.backgroundColor,
    this.overridePadding = false,
    this.animationDuration = 1500,
  }) :  assert(title != null),
        assert(tag != null),
        assert(child != null),
        assert(backgroundColor != null),
        assert(animationDuration != null),
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
      duration: Duration(milliseconds: widget.animationDuration),
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
    EdgeInsets _defaultPadding = EdgeInsets.fromLTRB(20, 10, 20, 20,);
    EdgeInsets _overridedPadding = EdgeInsets.zero;
    if (widget.overridePadding) {
      _defaultPadding = EdgeInsets.zero;
      _overridedPadding = EdgeInsets.fromLTRB(20, 0, 20, 0,);
    }

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
          leading: IconButton(
            icon: Icon(
              LineIcons.angle_left,
              color: _defaultTextStyle.color,
            ),
            tooltip: "Indietro",
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Stack(
          children: [
            Container(color: widget.backgroundColor),
            SafeArea(
              bottom: false,
              // TODO: valutare il togliere la column
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: _defaultPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: _overridedPadding,
                            child: FadeSlideTransition(
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

class SobreroButton extends StatelessWidget {
  EdgeInsets margin;
  Widget suffixIcon;
  String text;
  Function onPressed;
  String tooltip;
  Color color, _textColor;

  SobreroButton({
    Key key,
    this.margin = EdgeInsets.zero,
    this.suffixIcon,
    this.onPressed,
    @required this.color,
    this.tooltip,
    @required this.text,
  }) :  assert(margin != null),
        assert(color != null),
        assert(text != null),
        super(key: key);

  @override
  Widget build (BuildContext context){
    UIHelper _uiHelper = UIHelper(context: context);
    _textColor = _uiHelper.textColorByBackground(color);
    return Container(
      alignment: Alignment.centerLeft,
      margin: margin,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(20),
            blurRadius: 10,
            spreadRadius: 10,
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: FlatButton.icon(
          padding: EdgeInsets.zero,
          icon: suffixIcon,
          //padding: EdgeInsets.zero,
          textColor: _textColor,
          label: Text(text),
          onPressed: onPressed,
        ),
      )
    );
  }
}

class HorizontalSectionList extends StatelessWidget {
  String sectionTitle;
  int itemCount;
  double height;
  HorizontalSectionListItemBuilder itemBuilder;

  HorizontalSectionList({
    Key key,
    @required this.sectionTitle,
    @required this.itemCount,
    @required this.height,
    @required this.itemBuilder
  }) :  assert(sectionTitle != null),
        assert(itemCount != null),
        assert(itemCount > 0),
        assert(height != null),
        assert(height > 0),
        assert(itemBuilder != null),
        super(key: key);

  @override
  Widget build (BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SafeArea(
          top: false,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              sectionTitle,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Container(
          height: height + 30,
          child: ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: itemCount,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, i) => itemBuilder(
              i == 0,
              i == itemCount -1,
              i,
            ),
          ),
        )
      ],
    );
  }
}

class SobreroPage extends StatelessWidget {
  SobreroPage({
    Key key,
    @required this.children,
    this.padding = const EdgeInsets.fromLTRB(15, 0, 15, 10),
  }) :  assert(children != null),
        assert(padding != null),
        super(key: key);

  EdgeInsets padding;
  List<Widget> children;
  @override
  Widget build(BuildContext context){
    return SingleChildScrollView(
      child: SafeArea(
        top: false,
        child: Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }
}

class MainViewSimpleContainer extends SobreroPage {
  MainViewSimpleContainer({
    Key key,
    List<Widget> children,
    String title,
  }) :  assert(title != null),
        assert(children != null),
        super(
          key: key,
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
        );
}

class SobreroDropdown extends StatelessWidget {
  String value;
  List<Widget> items;
  String hint;
  Function(String) onChanged;
  EdgeInsets margin;

  SobreroDropdown({
    Key key,
    @required this.value,
    @required this.items,
    this.margin = EdgeInsets.zero,
    this.hint = "",
    this.onChanged,
  }) :  assert(value != null),
        assert(items != null),
        assert(margin != null),
        assert(hint != null),
        super(key: key);

  @override
  Widget build(BuildContext context){
    return Center(
      child: Container(
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: DropdownButtonHideUnderline(
            child: Container(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Icon(
                        Icons.unfold_more,
                        color: Theme.of(context).primaryColor
                    ),
                  ),
                  isExpanded: true,
                  hint: Text(
                    hint,
                    overflow: TextOverflow.ellipsis,
                  ),
                  value: value,
                  onChanged: onChanged,
                  items: items,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}