// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

// TODO: pulizia codice tiles 570

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

import 'package:mySobrero/cloud_connector/cloud2.dart';
import 'package:mySobrero/feed/feed_detail.dart';
import 'package:mySobrero/common/definitions.dart';
import 'package:mySobrero/common/expandedsection.dart';
import 'package:mySobrero/common/profiles.dart';
import 'package:mySobrero/feed/sobrero_feed.dart';
import 'package:mySobrero/localization/localization.dart';
import 'package:mySobrero/reapi3.dart';
import 'package:mySobrero/globals.dart' as globals;
import 'package:mySobrero/tiles/image_link_tile.dart';
import 'package:mySobrero/tiles/news_tile.dart';
import 'package:mySobrero/ui/helper.dart';
import 'package:mySobrero/ui/layouts.dart';
import 'package:mySobrero/ui/tiles.dart';
import 'package:mySobrero/ui/user_header.dart';


class Homepage extends StatefulWidget {
  UnifiedLoginStructure unifiedLoginStructure;
  reAPI3 apiInstance;
  SobreroFeed feed;
  SwitchPageCallback switchPageCallback;

  Homepage({
    Key key,
    @required this.unifiedLoginStructure,
    @required this.apiInstance,
    @required this.feed,
    @required this.switchPageCallback,
  }) :  assert(unifiedLoginStructure != null),
        assert(apiInstance != null),
        assert(feed != null),
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

  List<CompitoStructure> weekAssignments = List<CompitoStructure>();

  @override
  void initState(){
    super.initState();
    double _marksWeights = 0;
    if (widget.unifiedLoginStructure.voti1Q.length > 0){
      _marksMean = 0;
      _marksWeights = 0;
      widget.unifiedLoginStructure.voti1Q.forEach((element) {
        _marksMean += element.votoValore * element.pesoValore;
        _marksWeights += element.pesoValore;
      });
      _marksMean /= _marksWeights;
    }
    if (widget.unifiedLoginStructure.voti2Q.length > 0){
      _marksMean = 0;
      _marksWeights = 0;
      widget.unifiedLoginStructure.voti2Q.forEach((element) {
        _marksMean += element.votoValore * element.pesoValore;
        _marksWeights += element.pesoValore;
      });
      _marksMean /= _marksWeights;
    }

    if (widget.unifiedLoginStructure.comunicazioni.length > 0){
      lastCircular = widget.unifiedLoginStructure.comunicazioni[0].contenuto;
      if (lastCircular.length > 100)
        lastCircular = lastCircular.substring(0, 100) + "...";
      lastNoticeSender = widget.unifiedLoginStructure.comunicazioni[0].mittente;
      String _sender = widget.unifiedLoginStructure.comunicazioni[0].mittente;
      if (_sender.toUpperCase() == "DIRIGENTE")
        lastNoticeSender = "Dirigente";
      else lastNoticeSender = "Segreteria Amm.va";
    }

    DateTime today = DateTime.now();
    bool isCurrentWeek = false;
    var weekStart = today.subtract(new Duration(days: today.weekday - 1));
    var formatter = new DateFormat('DD/MM/yyyy');
    weekAssignments = List<CompitoStructure>();
    widget.unifiedLoginStructure.compiti.forEach((element) {
      DateTime assignmentDate = formatter.parse(element.data);
      isCurrentWeek = assignmentDate.compareTo(weekStart) >= 0;
      if (isCurrentWeek) this.weekAssignments.add(element);
    });

    CloudConnector.getRemoteHeadingNews().then(
            (value) => setState((){
          _remoteNotice = value;
        })
    );

    _parentNoticeRecognizer = TapGestureRecognizer()..onTap = (){
      setState((){
        expandedParentNotice = !expandedParentNotice;
      });
    };
    studentAccount = widget.unifiedLoginStructure.user.livello == "4";
  }

  @override
  void dispose(){
    _parentNoticeRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SobreroLayout.rPage(
    overridePadding: true,
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
                          LineIcons.warning,
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
                name: widget.unifiedLoginStructure.user.nome,
                year: widget.unifiedLoginStructure.user.classe,
                section: widget.unifiedLoginStructure.user.sezione,
                course: widget.unifiedLoginStructure.user.corso,
                profileURL: globals.profileURL,
              ),
              /// Intestazione remota
              ExpandedSection(
                expand: _remoteNotice.headingNewsEnabled,
                child: SobreroGradientTile(
                  padding: EdgeInsets.only(top: 15),
                  colors: [
                    Color(0xFFf09819),
                    Color(0xFFff5858)
                  ],
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            LineIcons.warning,
                            size: 25,
                            color: Colors.white,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                AppLocalizations.of(context).translate('studInfoTitle'),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Text(
                      _remoteNotice.headingNewsBody,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              SobreroLayout.r2x1w(
                margin: EdgeInsets.only(top: 15),
                isWide: UIHelper.isWide(context),
                left: SobreroWaveTile(
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
                      LineIcons.dropbox,
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
                  onTap: () => widget.switchPageCallback(1),
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
                    Padding(
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
                              //toBeginningOfSentenceCase("lastCircularSender"),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    AutoSizeText(
                      lastCircular,
                      minFontSize: 12,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: new TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: AutoSizeText(
                        AppLocalizations.of(context).translate('lastNotice'),
                        style: new TextStyle(color: Color(0xFFFFFFFF)),
                      ),
                    )
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
                LineIcons.newspaper_o,
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