// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPG 3.0 license that can be
// found in the LICENSE file.

import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class SobreroAppBar extends StatefulWidget implements PreferredSizeWidget{
  final double elevation;
  final double topCorrection;
  final GlobalKey refreshGlobalKey;
  final GlobalKey menuGlobalKey;
  final Function onRefresh;
  final bool isLoading;

  @override
  Size get preferredSize => Size(
      double.infinity,
      Platform.isMacOS ? 100 : 66
  );

  SobreroAppBar({
    Key key,
    this.elevation = 0,
    this.topCorrection = 0,
    @required this.refreshGlobalKey,
    @required this.menuGlobalKey,
    @required this.onRefresh,
    this.isLoading = false,
  }) :  assert(elevation != null),
        assert(elevation >= 0),
        assert(elevation <= 1),
        super(key: key);

  SobreroAppBarState createState() => SobreroAppBarState();
}

class SobreroAppBarState extends State<SobreroAppBar>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = Tween<double>(
        begin: 0,
        end: 2 * math.pi
    ).animate(_controller)..addListener(() {
        setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _oldAnimate = false;

  @override
  Widget build(BuildContext context) {
    if (_oldAnimate != widget.isLoading){
      _oldAnimate = widget.isLoading;
      if (widget.isLoading) {
        _controller.repeat();
      }
      else _controller.animateTo(
        1,
        duration: Duration(milliseconds: 700),
        curve: Curves.ease,
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(widget.elevation * 0.1),
            blurRadius: 10,
            spreadRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            (Platform.isMacOS ? 47 : 3) - widget.topCorrection,
            20,
            3 + widget.topCorrection,
          ),
          child: Row(
            children: [
              IconButton(
                key: widget.menuGlobalKey,
                icon: Icon(
                  TablerIcons.menu,
                  color: Theme.of(context).primaryColor,
                ),
                //iconSize: 25,
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
              Spacer(),
              Hero(
                tag: "main_logosobre",
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset('assets/images/logo_sobrero_grad1.png'),
                ),
              ),
              Spacer(),
              IconButton(
                key: widget.refreshGlobalKey,
                icon: Transform.rotate(
                  angle: _animation.value,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: Icon(
                      TablerIcons.refresh,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                onPressed: widget.onRefresh,
              ),
            ],
          ),
        ),
      ),
    );
  }
}