import 'package:flutter/material.dart';

Dialog singleButtonDialog ({@required String headingImage, @required String title, @required String content, @required String buttonText, @required Function buttonCallback, @required BuildContext context}) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), //this right here
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 200),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
              borderRadius: new BorderRadius.circular(8.0),
              child: Image.asset(headingImage)),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Text(title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: Text(content,
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Expanded(
                    flex: 1,
                    child: OutlineButton(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      onPressed: buttonCallback,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7.0))),
                      color: Theme.of(context).primaryColor,
                      child: Text(buttonText),
                    ),
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