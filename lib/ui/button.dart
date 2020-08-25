// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mySobrero/ui/helper.dart';

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
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
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
          ),
        )
    );
  }
}

class SobreroDrawerButton extends StatelessWidget {
  EdgeInsets margin;
  IconData suffixIcon;
  String text;
  Function onPressed;
  String tooltip;
  Color color, _textColor;
  bool isSelected;

  SobreroDrawerButton({
    Key key,
    this.margin = EdgeInsets.zero,
    this.suffixIcon,
    this.onPressed,
    this.isSelected = false,
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
    return AnimatedContainer(
      alignment: Alignment.centerLeft,
      duration: Duration(milliseconds: 200),
      margin: margin,
      decoration: BoxDecoration(
        color: isSelected ? color : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          if (isSelected) BoxShadow(
            color: color.withAlpha(20),
            blurRadius: 10,
            spreadRadius: 10,
          ),
        ],
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onPressed,
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 15),
                  child: Icon(
                    suffixIcon,
                    color: isSelected ? _textColor : color,
                  ),
                ),
                Text(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? _textColor : color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
