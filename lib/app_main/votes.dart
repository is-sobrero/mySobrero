// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:expandable/expandable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:mySobrero/cloud_connector/cloud.dart';
import 'package:mySobrero/custom/dropdown.dart';
import 'package:mySobrero/localization/localization.dart';
import 'package:mySobrero/reAPI/reapi.dart';
import 'package:mySobrero/reAPI/types.dart';
import 'package:mySobrero/ui/data_ui.dart';
import 'package:mySobrero/ui/dropdown.dart';
import 'package:mySobrero/ui/helper.dart';
import 'package:mySobrero/ui/layouts.dart';
import 'package:mySobrero/ui/toggle.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import 'package:animations/animations.dart';

import 'package:mySobrero/common/definitions.dart';
import 'package:mySobrero/common/pageswitcher.dart';
import 'package:mySobrero/common/ui.dart';
import 'package:mySobrero/situazione.dart';

class VotesPage extends StatefulWidget {
  VotesPage({
    Key key,
  }) :  super(key: key);

  @override
  _VotesPageState createState() => _VotesPageState();
}

class _VotesPageState extends State<VotesPage>
    with AutomaticKeepAliveClientMixin<VotesPage> {
  @override
  bool get wantKeepAlive => true;

  Map<String, SituazioneElement> _goals1t, _goals2t;
  List<String> _subj1t, _subj2t;
  Future<Map<String, int>> _goals;

  int periodFilter = 0, filterIndex = 0;

  void initState(){
    super.initState();
    _subj1t = _getSubjects(reAPI4.instance.getStartupCache().marks_firstperiod);
    _subj2t = _getSubjects(reAPI4.instance.getStartupCache().marks_finalperiod);

    _goals1t = _getGoalsMap(reAPI4.instance.getStartupCache().marks_firstperiod);
    _goals2t = _getGoalsMap(reAPI4.instance.getStartupCache().marks_finalperiod);

    _goals = CloudConnector.getGoals(token: reAPI4.instance.getSession());

    if (reAPI4.instance.getStartupCache().marks_finalperiod.length > 0)
      periodFilter = 1;
  }

  Map<String, SituazioneElement> _getGoalsMap(
      List<Mark> votes){
    Map<String, double> votesSum = new Map<String, double>();
    Map<String, double> votesCount = new Map<String, double>();
    Map<String, SituazioneElement> tempReturn =
      new Map<String, SituazioneElement>();

    votes.forEach((mark) {
      if (!votesSum.containsKey(mark.subject)){
        votesSum[mark.subject] = 0;
        votesCount[mark.subject] = 0;
      }
      if (mark.mark > 0){
        votesSum[mark.subject] += mark.mark * mark.weight;
        votesCount[mark.subject] += mark.weight;
      }
    });

    votesSum.forEach((key, value){
      if (votesCount[key] > 0){
        tempReturn[key] = SituazioneElement(
            votesCount[key].toInt() ~/ 100, votesSum[key] / votesCount[key]
        );
      }
    });
    return tempReturn;
  }

  List<String> _getSubjects (List<Mark> marks) {
    List<String> tempReturn = new List<String>();
    // TODO: fix context localization
    tempReturn.add("Tutte le materie");

    marks.forEach((mark) {
      String m = mark.subject;
      if (!tempReturn.contains(m)) tempReturn.add(m);
    });
    return tempReturn;
  }

  Widget _generateMarkTile(Mark mark){
    List<Color> _entryBackground = AppColorScheme.greenGradient;
    if (mark.mark >= 6 && mark.mark < 7)
      _entryBackground = AppColorScheme.yellowGradient;
    if (mark.mark < 6)
      _entryBackground = AppColorScheme.redGradient;
    if (mark.mark == 0)
      _entryBackground = AppColorScheme.blueGradient;

    double _overallLuminance = _entryBackground[1].computeLuminance();
    Color _textColor =  _overallLuminance > 0.45 ? Colors.black : Colors.white;
    var _comment = mark.comment ?? AppLocalizations.of(context).translate('noComment');

    return ExpandableNotifier(
      child: Container (
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          gradient: LinearGradient(
            begin: FractionalOffset.topRight,
            end: FractionalOffset.bottomRight,
            colors: _entryBackground,
          ),
          boxShadow: [
            BoxShadow(
              color: _entryBackground[1].withOpacity(0.4),
              offset: const Offset(1.1, 1.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: Expandable(
          collapsed: ExpandableButton(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Text(
                      mark.mark.toString(), //TODO: implementare vototxt
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: _textColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      mark.subject,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _textColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          expanded: ExpandableButton(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Text(
                          mark.mark.toString(), //TODO: implementare vototxt
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: _textColor,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          mark.subject,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                      "${AppLocalizations.of(context).translate('markDate')}: ${mark.date}",
                      style: TextStyle(color: _textColor,),
                  ),
                  Text(
                      "${AppLocalizations.of(context).translate('markType')}: ${mark.tipologia}",
                      style: TextStyle(color: _textColor,),
                  ),
                  Text(
                      "${AppLocalizations.of(context).translate('markProf')}: ${mark.professor}",
                      style: TextStyle(color: _textColor,),
                  ),
                  Text(
                      "${AppLocalizations.of(context).translate('markWeight')}: ${mark.weight}\n",
                      style: TextStyle(color: _textColor,),
                  ),
                  Text(
                      _comment,
                      style: TextStyle(color: _textColor,),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _generatePeriodView(List<Mark> marks, int columns, int key){
    if (marks.isEmpty)
      return SobreroEmptyState(
        emptyStateKey: "noMarks",
      );

    List<FlSpot> _marksSpots = new List();
    int _x = 0;

    String _filterString = _subj1t[filterIndex];
    if (periodFilter != 0) _filterString = _subj2t[filterIndex];

    List<Mark> _filteredList = new List<Mark>();
    marks.forEach((mark) {
      if (mark.subject == _filterString || filterIndex == 0){
        if (mark.mark > 0)
          _marksSpots.add(
            FlSpot(
              200 - (_x++).toDouble(),
              mark.mark,
            ),
          );
        _filteredList.add(mark);
      }
    });

    FlLine _defaultLine = FlLine(
      color: Theme.of(context).textTheme.bodyText1.color.withAlpha(100),
      strokeWidth: 1,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      key: ValueKey<int>(key),
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 15),
          height: 150,
          child: LineChart(
            LineChartData(
              titlesData: FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                getDrawingHorizontalLine: (value) => _defaultLine,
                getDrawingVerticalLine: (value) => _defaultLine,
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: _marksSpots,
                  curveSmoothness: 0.5,
                  isCurved: false,
                  colors: [
                    AppColorScheme.primaryColor,
                    AppColorScheme.primaryColor,
                  ],
                  belowBarData: BarAreaData(
                    show: true,
                    colors: AppColorScheme.appGradient.map(
                            (color) => color.withOpacity(0.3)
                    ).toList(),
                    gradientFrom: Offset(0, 0),
                    gradientTo: Offset(0, 1),
                  ),
                )
              ],
            ),
          ),
        ),
        WaterfallFlow.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: _filteredList.length,
          itemBuilder: (context, i) => _generateMarkTile(_filteredList[i]),
          gridDelegate: SliverWaterfallFlowDelegate(
            crossAxisCount: columns,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            lastChildLayoutTypeBuilder: (index) => index == _filteredList.length
                ? LastChildLayoutType.foot
                : LastChildLayoutType.none,
          ),
        )
      ],
    );
  }

  // TODO: pulizia codice voti
  int customFilter = 0;

  @override
  Widget build(BuildContext context) {
    List<String> currentSubjects = periodFilter == 0 ? _subj1t : _subj2t;
    List<Mark> _currentMarks = periodFilter == 0
        ? reAPI4.instance.getStartupCache().marks_firstperiod
        : reAPI4.instance.getStartupCache().marks_finalperiod;
    return SobreroLayout.rPage(
      children: [
        Stack(
          children: [
            Row(
              children: [
                Text(
                  AppLocalizations.of(context).translate('allMarks'),
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                  ),
                ),
                Spacer(),
                if (_currentMarks.isNotEmpty) FutureBuilder<Map<String, int>>(
                    future: _goals,
                    builder: (context, snapshot){
                      if (snapshot.hasData){
                        return FlatButton(
                          child: Row(
                            children: <Widget>[
                              Text(AppLocalizations.of(context).translate('goals'), style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Icon(TablerIcons.flag, size: 20, color: Theme.of(context).primaryColor,),
                              ),
                            ],
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___)  => SituazioneView(
                                situazione1Q: _goals1t, situazione2Q: _goals2t,
                                obbiettivi: snapshot.data,
                                onObbiettiviChange: (_nob){
                                  _goals = CloudConnector.getGoals(
                                      token: reAPI4.instance.getSession()
                                  );
                                  setState(() {});
                                  },
                              ),
                              transitionDuration: Duration(milliseconds: UIHelper.pageAnimDuration),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return SharedAxisTransition(
                                  child: child,
                                  animation: animation,
                                  secondaryAnimation: secondaryAnimation,
                                  transitionType: SharedAxisTransitionType.scaled,
                                );
                                },
                            ),
                          ),
                          padding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        );
                      } else if (snapshot.hasError){
                        return Row(
                          children: <Widget>[
                            Text(AppLocalizations.of(context).translate('goalsError'), style: TextStyle(color: Theme.of(context).errorColor),),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Icon(Icons.error, color: Theme.of(context).errorColor,),
                            ),
                          ],
                        );
                      }
                      return Row(
                        children: <Widget>[
                          Text(AppLocalizations.of(context).translate('loadingGoals'), style: TextStyle(color: Theme.of(context).disabledColor),),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: SpinKitDualRing(
                              color: Theme.of(context).disabledColor,
                              size: 20,
                              lineWidth: 3,
                            ),
                          ),
                        ],
                      );
                    }
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: UIHelper.isWide(context) ? 0 : 40.0),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5, top: 3),
                  child: SobreroToggle(
                    values: [
                      AppLocalizations.of(context).translate('firstPeriod'),
                      AppLocalizations.of(context).translate('secondPeriod'),
                    ],
                    onToggleCallback: (val) => setState(() => periodFilter = val),
                    selectedItem: periodFilter,
                    width: 200,
                  ),
                ),
              ),
            ),
          ],
        ),
        SobreroDropdown(
          margin: EdgeInsets.only(top: 8, bottom: 20),
          value: currentSubjects[filterIndex],
          onChanged: (String value) {
            filterIndex = currentSubjects.indexOf(value);
            setState(() {});
          },
          items: _subj1t.map((String user) {
            return CustomDropdownMenuItem<String>(
              value: user,
              child: Text(
                user,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
        ),
        PageTransitionSwitcher2(
          reverse: periodFilter == 0,
          layoutBuilder: (_entries) => Stack(
            children: _entries
                .map<Widget>((entry) => entry.transition)
                .toList(),
            alignment: Alignment.topLeft,
          ),
          duration: Duration(milliseconds: 700),
          transitionBuilder: (c, p, s) => SharedAxisTransition(
            fillColor: Colors.transparent,
            animation: p,
            secondaryAnimation: s,
            transitionType: SharedAxisTransitionType.horizontal,
            child: c,
          ),
          child: _generatePeriodView(
            _currentMarks,
            UIHelper.columnCount(context),
            periodFilter,
          ),
        ),
      ],
    );
  }
}