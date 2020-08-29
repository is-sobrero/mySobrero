// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'package:expandable/expandable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mySobrero/cloud_connector/cloud2.dart';
import 'package:mySobrero/custom/dropdown.dart';
import 'package:mySobrero/localization/localization.dart';
import 'package:mySobrero/ui/data_ui.dart';
import 'package:mySobrero/ui/helper.dart';
import 'package:mySobrero/ui/layouts.dart';
import 'package:mySobrero/ui/toggle.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import 'package:animations/animations.dart';

import 'package:mySobrero/common/definitions.dart';
import 'package:mySobrero/common/pageswitcher.dart';
import 'package:mySobrero/common/ui.dart';
import 'package:mySobrero/reapi3.dart';
import 'package:mySobrero/situazione.dart';

class VotesPage extends StatefulWidget {
  List<VotoStructure> voti1q, voti2q;
  UnifiedLoginStructure unifiedLoginStructure;
  reAPI3 apiInstance;

  VotesPage({
    Key key,
    @required this.unifiedLoginStructure,
    @required this.apiInstance,
  }) :  assert(unifiedLoginStructure != null),
        assert(apiInstance != null),
        voti1q = unifiedLoginStructure.voti1Q,
        voti2q = unifiedLoginStructure.voti2Q,
        super(key: key);

  @override
  _VotesPageState createState() => _VotesPageState();
}

class _VotesPageState extends State<VotesPage>
    with AutomaticKeepAliveClientMixin<VotesPage> {
  @override
  bool get wantKeepAlive => true;

  Map<String, SituazioneElement> situazione1Q, situazione2Q;
  List<String> materie1q, materie2q;
  Future<Map<String, int>> _goals;

  int periodFilter = 0, filterIndex = 0;

  void initState(){
    super.initState();
    materie1q = _generateSubjectsList(widget.voti1q);
    materie2q = _generateSubjectsList(widget.voti2q);

    situazione1Q = _generateSituazioneMap(widget.voti1q);
    situazione2Q = _generateSituazioneMap(widget.voti2q);

    _goals = CloudConnector.getGoals(token: widget.apiInstance.getSession());

    if (widget.voti2q.length > 0) periodFilter = 1;
  }

  Map<String, SituazioneElement> _generateSituazioneMap(
      List<VotoStructure> votes){
    Map<String, double> votesSum = new Map<String, double>();
    Map<String, double> votesCount = new Map<String, double>();
    Map<String, SituazioneElement> tempReturn =
      new Map<String, SituazioneElement>();

    votes.forEach((mark) {
      if (!votesSum.containsKey(mark.materia)){
        votesSum[mark.materia] = 0;
        votesCount[mark.materia] = 0;
      }
      if (mark.votoValore > 0){
        votesSum[mark.materia] += mark.votoValore * mark.pesoValore;
        votesCount[mark.materia] += mark.pesoValore;
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

  List<String> _generateSubjectsList (List<VotoStructure> marks) {
    List<String> tempReturn = new List<String>();
    // TODO: fix context loc
    tempReturn.add("Tutte le materie");

    marks.forEach((mark) {
      String m = mark.materia;
      if (!tempReturn.contains(m)) tempReturn.add(m);
    });
    return tempReturn;
  }

  Widget _generateMarkTile(VotoStructure mark){
    List<Color> _entryBackground = AppColorScheme.greenGradient;
    if (mark.votoValore >= 6 && mark.votoValore < 7)
      _entryBackground = AppColorScheme.yellowGradient;
    if (mark.votoValore < 6)
      _entryBackground = AppColorScheme.redGradient;
    if (mark.votoValore == 0)
      _entryBackground = AppColorScheme.blueGradient;

    double _overallLuminance = _entryBackground[1].computeLuminance();
    Color _textColor =  _overallLuminance > 0.45 ? Colors.black : Colors.white;
    var _comment = mark.commento ?? AppLocalizations.of(context).translate('noComment');

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
                      mark.votoTXT,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: _textColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      mark.materia,
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
                          mark.votoTXT,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: _textColor,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          mark.materia,
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
                      "${AppLocalizations.of(context).translate('markDate')}: ${mark.data}",
                      style: TextStyle(color: _textColor,),
                  ),
                  Text(
                      "${AppLocalizations.of(context).translate('markType')}: ${mark.tipologia}",
                      style: TextStyle(color: _textColor,),
                  ),
                  Text(
                      "${AppLocalizations.of(context).translate('markProf')}: ${mark.docente}",
                      style: TextStyle(color: _textColor,),
                  ),
                  Text(
                      "${AppLocalizations.of(context).translate('markWeight')}: ${mark.peso}\n",
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

  Widget _generatePeriodView(List<VotoStructure> marks, int columns, int key){
    if (marks.isEmpty)
      return SobreroEmptyState(
        emptyStateKey: "noMarks",
      );

    List<FlSpot> _marksSpots = new List();
    int _x = 0;

    String _filterString = materie1q[filterIndex];
    if (periodFilter != 0) _filterString = materie2q[filterIndex];

    List<VotoStructure> _filteredList = new List<VotoStructure>();
    marks.forEach((mark) {
      if (mark.materia == _filterString || filterIndex == 0){
        if (mark.pesoValore > 0)
          _marksSpots.add(
            FlSpot(
              200 - (_x++).toDouble(),
              mark.votoValore,
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
    List<String> currentSubjects = periodFilter == 0 ? materie1q : materie2q;
    List<VotoStructure> _currentMarks = periodFilter == 0
        ? widget.voti1q
        : widget.voti2q;
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
                if (!_currentMarks.isEmpty) FutureBuilder<Map<String, int>>(
                    future: _goals,
                    builder: (context, snapshot){
                      if (snapshot.hasData){
                        return FlatButton(
                          child: Row(
                            children: <Widget>[
                              Text(AppLocalizations.of(context).translate('goals'), style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Icon(LineIcons.flag, size: 20, color: Theme.of(context).primaryColor,),
                              ),
                            ],
                          ),
                          onPressed: () => Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___)  => SituazioneView(
                                  situazione1Q: situazione1Q, situazione2Q: situazione2Q,
                                  apiInstance: widget.apiInstance,
                                  obbiettivi: snapshot.data, onObbiettiviChange: (_nob){
                                    _goals = CloudConnector.getGoals(token: widget.apiInstance.getSession());
                                    setState(() {});
                                  },
                                ),
                                transitionDuration: Duration(milliseconds: UIHelper.pageAnimDuration),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  var begin = Offset(0.0, 1.0);
                                  var end = Offset.zero;
                                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOutExpo));
                                  var offsetAnimation = animation.drive(tween);
                                  return SharedAxisTransition(
                                    child: child,
                                    animation: animation,
                                    secondaryAnimation: secondaryAnimation,
                                    transitionType: SharedAxisTransitionType.scaled,
                                  );
                                },

                              )
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
          items: materie1q.map((String user) {
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