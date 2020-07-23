// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class SobreroToggle extends StatefulWidget {
  final List<String> values;
  final ValueChanged onToggleCallback;
  int selectedItem;
  double width;
  SobreroToggle(
      {Key key,
        @required this.values,
        @required this.onToggleCallback,
        @required this.selectedItem,
        @required this.width})
      : assert(values != null),
        assert(onToggleCallback != null),
        assert(selectedItem != null),
        assert(width != null),
        super(key: key);

  @override
  _SobreroToggleState createState() => _SobreroToggleState();
}

class _SobreroToggleState extends State<SobreroToggle> {
  @override
  Widget build(BuildContext context) {
    Alignment al = Alignment.centerLeft;
    if (widget.selectedItem == 2) al = Alignment.centerRight;
    if (widget.selectedItem == 1) if (widget.values.length == 3)
      al = Alignment.center;
    else
      al = Alignment.centerRight;
    double singleItem = widget.width / widget.values.length;
    return Container(
      width: widget.width,
      child: Stack(
        children: [
          Container(
            decoration: ShapeDecoration(
                color: Theme.of(context).canvasColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
            width: widget.width,
            height: 30,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.values.length,
                    (index) => GestureDetector(
                  onTap: () => widget.onToggleCallback(index),
                  child: Container(
                    width: singleItem,
                    child: Text(
                      widget.values[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF918f95)),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedAlign(
            alignment: al,
            duration: Duration(milliseconds: 350),
            curve: Curves.ease,
            child: Container(
              alignment: Alignment.center,
              width: singleItem,
              height: 30,
              decoration: ShapeDecoration(
                  color: Theme.of(context).toggleableActiveColor,
                  shadows: [
                    BoxShadow(
                      color: Colors.black12.withAlpha(12),
                      blurRadius: 10,
                      spreadRadius: 10,
                    )
                  ],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              child: Text(
                widget.values[widget.selectedItem],
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
