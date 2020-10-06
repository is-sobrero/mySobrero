// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

// TODO: pulizia codice tiles 570

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:intl/intl.dart';
import 'package:animations/animations.dart';

import 'package:mySobrero/cloud_connector/cloud.dart';
import 'package:mySobrero/compiti.dart';
import 'package:mySobrero/covid19_policy.dart';
import 'package:mySobrero/feed/feed_detail.dart';
import 'package:mySobrero/common/definitions.dart';
import 'package:mySobrero/common/expandedsection.dart';
import 'package:mySobrero/common/profiles.dart';
import 'package:mySobrero/feed/sobrero_feed.dart';
import 'package:mySobrero/localization/localization.dart';
import 'package:mySobrero/reAPI/reapi.dart';
import 'package:mySobrero/reAPI/types.dart';
import 'package:mySobrero/globals.dart' as globals;
import 'package:mySobrero/tiles/gradient_tile.dart';
import 'package:mySobrero/tiles/image_link_tile.dart';
import 'package:mySobrero/tiles/news_tile.dart';
import 'package:mySobrero/tiles/ratio_tile.dart';
import 'package:mySobrero/tiles/wave_tile.dart';
import 'package:mySobrero/ui/helper.dart';
import 'package:mySobrero/ui/layouts.dart';
import 'package:mySobrero/ui/user_header.dart';

class Homepage extends StatefulWidget {
  SobreroFeed feed;
  SwitchPageCallback switchPageCallback;
  GlobalKey marksGlobalKey;

  Homepage({
    Key key,
    @required this.feed,
    @required this.switchPageCallback,
    @required this.marksGlobalKey,
  }) :  assert(feed != null),
        assert(switchPageCallback != null),
        super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with AutomaticKeepAliveClientMixin<Homepage> {
  @override
  bool get wantKeepAlive => true;

  RemoteNews _remoteNotice = RemoteNews.preFetch();
  bool expandedParentNotice = false;
  TapGestureRecognizer _parentNoticeRecognizer;

  double _marksMean = -1, lastSubject;
  String lastCircular = "", lastNoticeSender;
  bool studentAccount;

  List<Assignment> weekAssignments = List<Assignment>();

  @override
  void initState(){
    super.initState();
    double _marksWeights = 0;
    if (reAPI4.instance.getStartupCache().marks_firstperiod.length > 0){
      _marksMean = 0;
      _marksWeights = 0;
      reAPI4.instance.getStartupCache().marks_firstperiod.forEach((element) {
        _marksMean += element.mark * element.weight;
        _marksWeights += element.weight;
      });
      _marksMean /= _marksWeights;
    }
    if (reAPI4.instance.getStartupCache().marks_finalperiod.length > 0){
      _marksMean = 0;
      _marksWeights = 0;
      reAPI4.instance.getStartupCache().marks_finalperiod.forEach((element) {
        _marksMean += element.mark * element.weight;
        _marksWeights += element.weight;
      });
      _marksMean /= _marksWeights;
    }

    if (reAPI4.instance.getStartupCache().notices.length > 0){
      lastCircular = reAPI4.instance.getStartupCache().notices[0].body;
      if (lastCircular.length > 100)
        lastCircular = lastCircular.substring(0, 100) + "...";
      lastNoticeSender = reAPI4.instance.getStartupCache().notices[0].sender;
      String _sender = reAPI4.instance.getStartupCache().notices[0].sender;
      if (_sender.toUpperCase() == "DIRIGENTE")
        lastNoticeSender = "Dirigente";
      else lastNoticeSender = "Segreteria Amm.va";
    }

    DateTime today = DateTime.now();
    bool isCurrentWeek = false;
    var weekStart = today.subtract(new Duration(days: today.weekday - 1));
    var formatter = new DateFormat('DD/MM/yyyy');
    reAPI4.instance.getStartupCache().assignments.forEach((element) {
      DateTime assignmentDate = formatter.parse(element.date);
      isCurrentWeek = assignmentDate.compareTo(weekStart) >= 0;
      if (isCurrentWeek) this.weekAssignments.add(element);
    });

    reAPI4.instance.setMainscreenCallback(() => setState((){}));

    CloudConnector.getRemoteHeadingNews().then((value) => setState((){
      _remoteNotice = value;
    }));

    _parentNoticeRecognizer = TapGestureRecognizer()..onTap = (){
      setState((){
        expandedParentNotice = !expandedParentNotice;
      });
    };
    studentAccount = reAPI4.instance.getStartupCache().user.level == "4";
  }

  @override
  void dispose(){
    _parentNoticeRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SobreroLayout.rPage(
      overridePadding: true,
      overrideSafearea: true,
      children: [
        /// Avv. genitore, Intestazione usr, Intes. remota, Tiles
        SafeArea(
          top: false,
          bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
            child: Column(
              children: [
                /// Avviso account genitore
                if (!studentAccount) SobreroGradientTile(
                  padding: EdgeInsets.only(
                    bottom: _remoteNotice.headingNewsEnabled ? 10 : 0,
                  ),
                  colors: [
                    Color(0xFFFF416C),
                    Color(0xFFFF4B2B),
                  ],
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(
                            TablerIcons.alert_triangle,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: AppLocalizations.of(context).translate(
                                      'loggedAsParent'),
                                  style: TextStyle(color: Colors.white),
                                ),
                                TextSpan(
                                  text: expandedParentNotice
                                      ? AppLocalizations.of(context).translate(
                                      'showLess')
                                      : AppLocalizations.of(context).translate(
                                      'toLearnMore'),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: _parentNoticeRecognizer,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    ExpandedSection(
                      expand: expandedParentNotice,
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          AppLocalizations.of(context).translate(
                              'parentNotice'),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                /// Intestazione utente
                SobreroUserHeader(
                  name: reAPI4.instance.getStartupCache().user.name,
                  fullclass: reAPI4.instance.getStartupCache().user.fullclass,
                  course: reAPI4.instance.getStartupCache().user.course,
                  profileURL: globals.profileURL,
                ),
                /// Avviso COVID non firmato
                /// HACK: disabilitato fino a nuove disposizioni del dirigente
                /*ExpandedSection(
                    expand: reAPI4.showCovidNotice(
                      reAPI4.instance.getStartupCache().covid19info,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Image.asset(
                              "assets/images/covid_alert.png",
                              width: 27,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context).translate(
                                    "COVID19_INFO_NOT_ACCEPTED",
                                  ),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffFF4B2B),
                                  ),
                                ),
                                Text(
                                  AppLocalizations.of(context).translate(
                                    "COVID19_INFO_DESC",
                                  ),
                                  style: TextStyle(
                                    color: Color(0xffFF4B2B),
                                  ),
                                ),
                                FlatButton(
                                  textColor: Color(0xffFF4B2B),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          AppLocalizations.of(context).translate(
                                              "COVID19_ACCEPT_SCREEN_BUTTON"
                                          ),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Icon(TablerIcons.arrow_right_circle),
                                    ],
                                  ),
                                  onPressed: () => Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (a, b, c)  => Covid19Policy(),
                                      transitionDuration: Duration(
                                        milliseconds: UIHelper.pageAnimDuration,
                                      ),
                                      transitionsBuilder: (ctx, p, s, c) => SharedAxisTransition(
                                        animation: p,
                                        secondaryAnimation: s,
                                        transitionType: SharedAxisTransitionType.scaled,
                                        child: c,
                                      ),
                                    ),
                                  ),
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                ),*/
                /// Intestazione remota
                ExpandedSection(
                  expand: _remoteNotice.headingNewsEnabled,
                  child: SobreroGradientTile(
                    overridePadding: true,
                    padding: EdgeInsets.only(top: 15),
                    colors: [
                      Color(0xFFf09819),
                      Color(0xFFff5858)
                    ],
                    children: [
                      Container(
                        color: Colors.white.withAlpha(90),
                        child: Padding(
                          padding:EdgeInsets.fromLTRB(15,8,15,7.5),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                TablerIcons.info_circle,
                                size: 25,
                                color: Colors.black,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    AppLocalizations.of(context).translate('studInfoTitle'),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15,10,15,15),
                        child: Text(
                          _remoteNotice.headingNewsBody,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                SobreroLayout.r2x1w(
                  margin: EdgeInsets.only(top: 15),
                  isWide: UIHelper.isWide(context),
                  left: SobreroWaveTile(
                    key: widget.marksGlobalKey,
                    color: _marksMean < 0 ? Colors.blue
                        : (_marksMean >= 6)
                        ? ((_marksMean >= 7) ? Color(0xFF23cba7)
                        : Colors.orange) : Colors.red,
                    margin: EdgeInsets.only(right: 7.5),
                    flex: 1,
                    numberMark: _marksMean > 0 ? _marksMean : 5,
                    onTap: () => widget.switchPageCallback(1),
                    children: [
                      if (_marksMean > 0) Text(
                        _marksMean.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 65,
                          color: Colors.black,
                          height: 1,
                        ),
                      ),
                      if (_marksMean < 0) Icon(
                        TablerIcons.stack,
                        size: 70,
                        color: Colors.black,
                      ),
                      Text(
                        _marksMean > 0 ? "Media complessiva"
                            : "Nessun voto disponibile",
                        style: TextStyle(color: Colors.black),
                      )
                    ],
                  ),
                  right: SobreroRatioTile(
                    onTap: () => Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, a, b) => CompitiView(
                          //compiti: reAPI4.instance.getStartupCache().assignments,
                          settimana: weekAssignments,
                        ),
                        transitionDuration: Duration(milliseconds: UIHelper.pageAnimDuration),
                        transitionsBuilder: (ctx, prim, sec, child) => SharedAxisTransition(
                          animation: prim,
                          secondaryAnimation: sec,
                          transitionType: SharedAxisTransitionType.scaled,
                          child: child,
                        ),
                      ),
                    ),
                    margin: EdgeInsets.only(left: 7.5),
                    flex: 1,
                    colors : [
                      Color(0xFF359cd7),
                      Color(0xFF7d6efb),
                    ],
                    children: [
                      Text(
                        weekAssignments.length.toString(),
                        style: TextStyle(
                          fontSize: 65,
                          color: Colors.white,
                          height: 1,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context).translate(
                            'weekAssignments'
                        ),
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  bottom: SobreroRatioTile(
                    aspectRatio: 2,
                    margin: EdgeInsets.fromLTRB(
                      UIHelper.isWide(context) ? 15 : 0,
                      UIHelper.isWide(context) ? 0 : 15,
                      0,
                      0,
                    ),
                    flex: UIHelper.isWide(context) ? 1 : 0,
                    onTap: () => widget.switchPageCallback(2),
                    colors: [
                      Color(0xFFf1608a),
                      Color(0xFFaa68d2),
                    ],
                    children: [
                      if (lastNoticeSender != null) Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: <Widget>[
                            CircularProfile(
                              sender: lastNoticeSender,
                              radius: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                lastNoticeSender,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      if (lastNoticeSender != null) AutoSizeText(
                        lastCircular,
                        minFontSize: 10,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      if (lastNoticeSender != null) Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: AutoSizeText(
                          AppLocalizations.of(context).translate('lastNotice'),
                          style: new TextStyle(color: Color(0xFFFFFFFF)),
                        ),
                      ),
                      if (lastNoticeSender == null)
                        Icon(
                          TablerIcons.message_circle,
                          size: 70,
                          color: Colors.white,
                        ),
                      if (lastNoticeSender == null)
                        Text(
                          AppLocalizations.of(context).translate("noNotices"),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        /// News dal sobrero
        SafeArea(
          top: false,
          bottom: false,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15, right: 8),
                child: Icon(
                  TablerIcons.news,
                  size: 30,
                  color: Colors.red,
                ),
              ),
              Text(
                AppLocalizations.of(context).translate('newsFromSobrero'),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 450,
          child: ListView.builder(
            padding: EdgeInsets.all(15),
            itemCount: widget.feed.items.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, i) => SobreroNewsTile(
              safeLeft: i == 0,
              safeRight: i == widget.feed.items.length - 1,
              leadingImageUrl: widget.feed.items[i].thumbnail,
              title: widget.feed.items[i].title,
              builder: (_,__,___) => FeedDetailView(
                articolo: widget.feed.items[i],
              ),
            ),
          ),
        ),
        /// Remote notice
        if (_remoteNotice.bottomNoticeEnabled) SafeArea(
          top: false,
          child: ImageLinkTile(
            margin: EdgeInsets.all(15),
            colors: <Color>[
              Color(0xFFfa71cd),
              Color(0xFF6a11cb),
            ],
            imageUrl: _remoteNotice.bottomNoticeHeadingURL,
            title: _remoteNotice.bottomNoticeTitle,
            body: _remoteNotice.bottomNotice,
            detailsText: _remoteNotice.bottomNoticeLinkTitle,
            detailsUrl: _remoteNotice.bottomNoticeLink,
          ),
        ),
        //if (_remoteNotice.bottomNoticeEnabled)
      ],
    );
  }
}