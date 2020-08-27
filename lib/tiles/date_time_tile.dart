// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mySobrero/tiles/basic_tile.dart';
import 'package:mySobrero/ui/helper.dart';

class DateTimeTile extends StatelessWidget {
  DateTimeTile({
    Key key,
    @required this.title,
    this.color = null,
    this.dateFormat = 'dd/MM/yyyy HH:mm:ss',
    @required this.date,
    this.showHour = true,
    this.overridePadding = false,
    this.showShadow = true,
    this.margin = const EdgeInsets.only(bottom: 15),
    @required this.children,
  }) :  assert(title != null),
        assert(dateFormat != null),
        assert(date != null),
        super(key: key);

  final Color color;
  final String dateFormat;
  final String date;
  final String title;
  final bool showHour;
  final EdgeInsets margin;
  final bool showShadow, overridePadding;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final f = new DateFormat(dateFormat);
    //DateTime timestamp = f.parse("${a.data} ${a.orario ?? "00:00:00"}");
    DateTime timestamp = f.parse(date);
    final day = DateFormat.MMMMd(Platform.localeName).format(timestamp);
    final time = DateFormat('hh:mm').format(timestamp);
    return BasicTile(
      color: color,
      margin: margin,
      showShadow: showShadow,
      overridePadding: overridePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color == null
                        ? null : UIHelper.textColorByBackground(color),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(
                          day,
                          style: TextStyle(
                            color: color == null
                                ? null : UIHelper.textColorByBackground(color),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: Icon(
                            LineIcons.calendar_o,
                            size: 18,
                            color: color == null
                                ? null : UIHelper.textColorByBackground(color),
                          ),
                        )
                      ],
                    ),
                    if (showHour) Row(
                      children: <Widget>[
                        Text(
                          time,
                          style: TextStyle(
                            color: color == null
                                ? null : UIHelper.textColorByBackground(color),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: Icon(
                            LineIcons.clock_o,
                            size: 18,
                            color: color == null
                                ? null : UIHelper.textColorByBackground(color),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 8,),
          ...children,
        ],
      ),
    );
  }
}