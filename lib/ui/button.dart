// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:mySobrero/common/ui.dart';

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
    _textColor = UIHelper.textColorByBackground(color);
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
          child: suffixIcon != null ? FlatButton.icon(
            padding: EdgeInsets.zero,
            icon: suffixIcon,
            //padding: EdgeInsets.zero,
            textColor: _textColor,
            label: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: onPressed,
          ) : FlatButton(
            padding: EdgeInsets.zero,
            textColor: _textColor,
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: onPressed,
          ),
        )
    );
  }
}
