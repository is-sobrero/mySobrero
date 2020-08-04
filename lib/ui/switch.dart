// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import "package:flutter/material.dart";

class SobreroSwitch extends StatelessWidget {
  SobreroSwitch({Key key, @required this.value, @required this.onChanged,
    @required this.enabled})
      : assert(onChanged != null),
        assert(enabled != null),
        super(key: key);

  final bool value;
  final Function(bool) onChanged;
  final bool enabled;

  Color _onColor = Color(0xff46E387);
  Color _offColor = Colors.red;

  final Duration _animDuration = Duration(milliseconds: 250);
  final Curve _animCurve = Curves.easeInOut;

  @override
  Widget build(BuildContext context) {
    Color activeColor = _offColor;
    if (!enabled) activeColor = Colors.grey;
    else if (value) activeColor = _onColor;
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: _animDuration,
        curve: _animCurve,
        //margin: EdgeInsets.all(30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: activeColor,
          boxShadow: [
            BoxShadow(
              color: activeColor.withOpacity(0.3),
              blurRadius: 7,
              offset: Offset(0, 7),
            ),
          ],
        ),
        width: 45,
        height: 25,
        child: AnimatedAlign(
          duration: _animDuration,
          curve: _animCurve,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: AnimatedContainer(
            duration: _animDuration,
            curve: _animCurve,
            margin: EdgeInsets.fromLTRB(7, 5, 12, 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            width: value ? 5 : 13,
            height: 13,
          ),
        ),
      ),
    );
  }
}
