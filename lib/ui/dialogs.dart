// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import 'package:mySobrero/ui/button.dart';

class SobreroDialogSingle extends Dialog {
  SobreroDialogSingle({
    Key key,
    this.headingImage,
    this.headingWidget,
    @required this.title,
    @required this.buttonText,
    @required this.content,
    @required this.buttonCallback,
  }) : super (key: key);

  final String headingImage;
  final String title;
  final Widget headingWidget;
  final String buttonText;
  final Widget content;
  final Function buttonCallback;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), //this right here
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 300),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (headingImage != null )ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(headingImage),
            ),
            if (headingWidget != null) Padding(
              padding: const EdgeInsets.only(top: 15),
              child: headingWidget,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  10,
                  headingWidget == null ? 10 : 0,
                  10,10
              ),
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

class SobreroDialogNoAction extends Dialog {
  SobreroDialogNoAction({
    Key key,
    this.headingImage,
    this.headingWidget,
    @required this.title,
    @required this.content,
  }) : super (key: key);

  final String headingImage;
  final String title;
  final Widget headingWidget;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), //this right here
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 300),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (headingImage != null )ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(headingImage),
            ),
            if (headingWidget != null) Padding(
              padding: const EdgeInsets.only(top: 15),
              child: headingWidget,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  10,
                  headingWidget == null ? 10 : 0,
                  10,10
              ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SobreroDialogAbort extends Dialog {
  SobreroDialogAbort({
    Key key,
    this.headingImage,
    this.headingWidget,
    @required this.title,
    @required this.okButtonText,
    @required this.abortButtonText,
    @required this.content,
    @required this.okButtonCallback,
    @required this.abortButtonCallback,
  }) : super (key: key);

  final String headingImage;
  final String title;
  final String okButtonText;
  final String abortButtonText;
  final Widget content;
  final Widget headingWidget;
  final Function okButtonCallback;
  final Function abortButtonCallback;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), //this right here
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 300),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (headingImage != null )ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(headingImage),
            ),
            if (headingWidget != null) Padding(
              padding: const EdgeInsets.only(top: 15),
              child: headingWidget,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                10,
                  headingWidget == null ? 10 : 0,
                10,10
              ),
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: SobreroButton(
                          margin: EdgeInsets.only(right: 5, left: 10),
                          text: okButtonText,
                          suffixIcon: Icon(TablerIcons.check),
                          color: Theme.of(context).primaryColor,
                          onPressed: okButtonCallback,
                        ),
                      ),
                      Flexible(
                        child: SobreroButton(
                          text: abortButtonText,
                          suffixIcon: Icon(TablerIcons.ban),
                          margin: EdgeInsets.fromLTRB(5,0,10,10),
                          color: Colors.red,
                          onPressed: abortButtonCallback
                        ),
                      ),
                    ],
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