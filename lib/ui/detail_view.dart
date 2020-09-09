// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class SobreroDetailView extends StatefulWidget {
  String title;
  Widget child;
  bool overridePadding;

  SobreroDetailView({
    Key key,
    @required this.title,
    @required this.child,
    this.overridePadding = false,
  }) :  assert(title != null),
        assert(child != null),
        super(key: key);

  @override
  _SobreroDetailViewState createState() => _SobreroDetailViewState();
}

class _SobreroDetailViewState extends State<SobreroDetailView>
    with SingleTickerProviderStateMixin {

  final double _preferredAppBarHeight = 56.0;
  final double _preferredAppBarElevation = 1;
  ScrollController _scrollController;
  double _appBarElevation = 0.0;
  double _appBarTitleOpacity = 0.0;

  @override
  void initState(){
    super.initState();

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
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets _defaultPadding = EdgeInsets.fromLTRB(20, 10, 20, 20,);
    EdgeInsets _overridedPadding = EdgeInsets.zero;
    if (widget.overridePadding) {
      _defaultPadding = EdgeInsets.zero;
      _overridedPadding = EdgeInsets.fromLTRB(20, 0, 20, 0,);
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 65),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_appBarElevation * 0.1),
                blurRadius: 10,
                spreadRadius: 10,
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(5,3,20,3),
              child: Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      LineIcons.angle_left,
                      color: Theme.of(context).textTheme.bodyText1.color,
                    ),
                    tooltip: "Indietro",
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  AnimatedOpacity(
                    opacity: _appBarTitleOpacity,
                    duration: Duration(milliseconds: 250),
                    child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.headline6.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ],
              ),
            )
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(color: Theme.of(context).scaffoldBackgroundColor),
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
                          child: Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        widget.child,
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}