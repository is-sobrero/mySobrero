// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

// TODO: pulizia codice tiles 570

import 'package:flutter/material.dart';
import 'package:mySobrero/ui/helper.dart';

class SobreroLayout {

  static _Internalr2x1w r2x1w ({
    Key key,
    @required isWide,
    @required left,
    @required right,
    @required bottom,
    margin = EdgeInsets.zero,
  }) => _Internalr2x1w(
    key: key,
    isWide: isWide,
    left: left,
    right: right,
    bottom: bottom,
    margin: margin,
  );

  static _InternalrDrawer rScaffold ({
    Key key,
    @required isWide,
    @required appBar,
    @required drawer,
    @required body,
  }) => _InternalrDrawer(
    key: key,
    isWide: isWide,
    appBar: appBar,
    drawer: drawer,
    body: body,
  );

  static _InternalRPage rPage ({
    Key key,
    @required children,
    overridePadding = false
  }) => _InternalRPage(
    key: key,
    children: children,
    overridePadding: overridePadding,
  );
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

class _InternalRPage extends StatelessWidget {
  List<Widget> children;
  bool overridePadding;

  _InternalRPage ({
    Key key,
    @required this.children,
    this.overridePadding = false,
  }) :  assert(children != null),
        super (key: key);

  @override
  Widget build (BuildContext context){
    bool _isPad = UIHelper.isPad(context);
    return SingleChildScrollView(
      child: SafeArea(
        top: _isPad,
        bottom: false,
        left: false,
        right: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            overridePadding ? 0 : 15,
            _isPad ? 10 : 0,
            overridePadding ? 0 : 15,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }
}

class _InternalrDrawer extends StatelessWidget {
  bool isWide;
  PreferredSizeWidget appBar;
  Widget drawer;
  Widget body;

  _InternalrDrawer({
    @required this.isWide,
    @required this.appBar,
    @required this.drawer,
    @required this.body,
    Key key,
  }) :  assert(appBar != null),
        assert(drawer != null),
        assert(body != null),
        super(key: key);

  @override
  Widget build(BuildContext context) => Row(
    children: [
      if (isWide) drawer,
      Expanded(
        child: Scaffold(
          appBar: isWide ? null : appBar,
          body: body,
          drawer: isWide ? null : drawer,
        ),
      ),
    ],
  );
}

class _Internalr2x1w extends StatelessWidget {
  bool isWide;
  Widget left, right, bottom;
  EdgeInsets margin;

  _Internalr2x1w ({
    Key key,
    @required this.isWide,
    @required this.left,
    @required this.right,
    @required this.bottom,
    this.margin = EdgeInsets.zero,
  });
  @override
  Widget build (BuildContext context) => Padding(
    padding: margin,
    child: Flex(
      direction: isWide ? Axis.horizontal : Axis.vertical,
      children: [
        Expanded(
          flex: isWide ? 1 : 0,
          child: Row(
            children: [
              left,
              right
            ],
          ),
        ),
        bottom,
      ],
    ),
  );
}
