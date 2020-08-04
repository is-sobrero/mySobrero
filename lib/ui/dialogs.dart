// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:mySobrero/ui/button.dart';

class SobreroDialogSingle extends Dialog {

  SobreroDialogSingle({
    Key key,
    @required this.headingImage,
    @required this.title,
    @required this.buttonText,
    @required this.content,
    @required this.buttonCallback,
  }) : super (key: key);

  final String headingImage;
  final String title;
  final String buttonText;
  final Widget content;
  final Function buttonCallback;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), //this right here
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 230),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(headingImage),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: content,
                        ),
                      ],
                    ),
                  ),
                  SobreroButton(
                    text: buttonText,
                    onPressed: buttonCallback,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}