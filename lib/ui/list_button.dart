// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:mySobrero/ui/switch.dart';

class SobreroListButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String caption;
  final Function onPressed;
  final bool showBorder;
  final bool enabled;

  SobreroListButton({Key key,
    @required this.icon,
    @required this.title,
    this.showBorder = true,
    this.enabled = true,
    @required this.caption,
    @required this.onPressed,
  }) :  assert (icon != null),
        assert(title != null),
        assert(caption != null),
        assert(onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.only(bottom: showBorder ? 10 : 0),
        child: Padding(
          padding: EdgeInsets.only(bottom: showBorder ? 10 : 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  icon,
                  size: 25,
                  color: enabled ? Theme.of(context).primaryColor :
                  Theme.of(context).disabledColor,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: enabled ? Theme.of(context).primaryColor :
                        Theme.of(context).disabledColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        caption,
                        style: TextStyle(
                          color: enabled ? null : Theme.of(context).disabledColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          border: showBorder ? Border(
            bottom: BorderSide(
              width: 1,
              color: Theme.of(context).textTheme.bodyText1.color.withAlpha(20),
            ),
          ) : null,
        ),
      ),
    );
  }
}

class SobreroListToggle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String caption;
  final Function(bool) onChanged;
  final bool value;
  final bool showBorder;
  final bool enabled;


  SobreroListToggle({Key key,
    @required this.icon,
    @required this.title,
    @required this.caption,
    this.showBorder = true,
    this.enabled = true,
    @required this.onChanged,
    @required this.value
  }) :  assert (icon != null),
        assert(title != null),
        assert(caption != null),
        assert(onChanged != null),
        assert(value != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => enabled ? onChanged(!value) : null,
      child: Container(
        margin: EdgeInsets.only(bottom: showBorder ? 10 : 0),
        child: Padding(
          padding: EdgeInsets.only(bottom: showBorder ? 10 : 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  icon,
                  size: 25,
                  color: enabled ? Theme.of(context).primaryColor :
                    Theme.of(context).disabledColor,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: enabled ? Theme.of(context).primaryColor :
                          Theme.of(context).disabledColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        caption,
                        style: TextStyle(
                          color: enabled ? null : Theme.of(context).disabledColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SobreroSwitch(
                value: value,
                enabled: enabled,
                onChanged: (_) {},
              )
            ],
          ),
        ),
        decoration: BoxDecoration(
          border: showBorder ? Border(
            bottom: BorderSide(
              width: 1,
              color: Theme.of(context).textTheme.bodyText1.color.withAlpha(20),
            ),
          ) : null,
        ),
      ),
    );
  }
}

