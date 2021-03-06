// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import 'package:mySobrero/common/pageswitcher.dart';
import 'package:mySobrero/reAPI/reapi.dart';
import 'package:mySobrero/reAPI/types.dart';
import 'package:mySobrero/tiles/date_time_tile.dart';
import 'package:mySobrero/ui/data_ui.dart';
import 'package:mySobrero/ui/detail_view.dart';
import 'package:mySobrero/ui/helper.dart';
import 'package:mySobrero/ui/toggle.dart';

class CompitiView extends StatefulWidget {
  List<Assignment> settimana;

  CompitiView({
    Key key,
    @required this.settimana,
  }) :  assert(settimana != null),
        super(key: key);

  @override
  _CompitiState createState() => _CompitiState();
}

class _CompitiState extends State<CompitiView> {
  int _periodSelector = 0;

  List<Assignment> _assignments = reAPI4.instance.getStartupCache().assignments;

  @override
  Widget build(BuildContext context) {
    List<Assignment> _selectedAssignments = _periodSelector == 0
        ? widget.settimana : _assignments;
    return SobreroDetailView(
      title: "Compiti",
      child: Column(
        children: [
          SobreroToggle(
            values: ["Settimana", "Tutti"],
            onToggleCallback: (val) => setState(() => _periodSelector = val),
            selectedItem: _periodSelector,
            width: 200,
            margin: EdgeInsets.only(bottom: 20, top: 10),
          ),
          PageTransitionSwitcher2(
            reverse: _periodSelector == 0,
            layoutBuilder: (_entries) => Stack(
              children: _entries
                  .map<Widget>((entry) => entry.transition)
                  .toList(),
              alignment: Alignment.topLeft,
            ),
            duration: Duration(milliseconds: UIHelper.pageAnimDuration),
            transitionBuilder: (c, p, s) => SharedAxisTransition(
              fillColor: Colors.transparent,
              animation: p,
              secondaryAnimation: s,
              transitionType: SharedAxisTransitionType.horizontal,
              child: c,
            ),
            child: Container(
              key: ValueKey<int>(_periodSelector),
              child: _selectedAssignments.length > 0 ? ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: _selectedAssignments.length,
                itemBuilder: (_, i) => DateTimeTile(
                  title: UIHelper.upperCaseFirst(
                    _selectedAssignments.reversed.toList()[i].subject,
                  ),
                  date: _selectedAssignments.reversed.toList()[i].date,
                  children: [
                    Text(
                      _selectedAssignments.reversed.toList()[i].description.trim(),
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                )
              ) : SobreroEmptyState(
                emptyStateKey: "noAssignments",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
